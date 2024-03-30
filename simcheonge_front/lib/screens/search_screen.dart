import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:simcheonge_front/screens/search_filter.dart';
import 'dart:ui';
import 'package:simcheonge_front/models/search_model.dart';
import 'package:simcheonge_front/services/search_api.dart';
import 'package:simcheonge_front/models/filter_model.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Content> _filteredPolices = [];
  int _currentPage = 0;
  bool _isFetching = false;
  bool _hasMore = true; // 더 불러올 데이터가 있는지
  final List<CategoryList> _selectedFilters = [];
  final int _totalPages = 0;

  late SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _initializeSpeech();
    _loadSelectedFilters();
    _controller.addListener(_searchListener);
    _scrollController.addListener(_scrollListener);

    _fetchData(); // 초기 데이터 로드
  }

  Future<void> _loadSelectedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final String? selectedFiltersStr = prefs.getString('selectedFilters');
    if (selectedFiltersStr != null) {
      final List<dynamic> selectedFiltersJson = jsonDecode(selectedFiltersStr);
      final List<CategoryList> loadedFilters =
          selectedFiltersJson.map((e) => CategoryList.fromJson(e)).toList();
      setState(() {
        _selectedFilters.clear();
        _selectedFilters.addAll(loadedFilters);
      });
    }
  }

  void _initializeSpeech() async {
    bool isAvailable = await _speech.initialize();
    if (isAvailable) {
      // 음성 입력이 사용 가능한 경우
      print('Speech recognition initialized successfully.');
    } else {
      // 음성 입력이 사용 불가능한 경우
      print('Error initializing speech recognition.');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _searchListener() {
    _loadSelectedFilters(); // 필터 정보를 업데이트합니다.
    _filteredPolices.clear();
    _currentPage = 0;
    _hasMore = true;
    _fetchData();
  }

  void _openFilterScreen() async {
    final returnedFilters = await Navigator.push<List<CategoryList>>(
      context,
      MaterialPageRoute(builder: (context) => const FilterScreen()),
    );

    if (returnedFilters != null) {
      _updateFilters(returnedFilters);
      _searchListener();
    }
  }

  Future<void> saveSelectedFilters(List<CategoryList> selectedFilters) async {
    final prefs = await SharedPreferences.getInstance();
    // 선택된 필터들을 JSON 문자열로 변환
    String selectedFiltersJson =
        jsonEncode(selectedFilters.map((filter) => filter.toJson()).toList());
    // 'selectedFilters' 키를 사용하여 저장
    await prefs.setString('selectedFilters', selectedFiltersJson);
    // 저장된 데이터 로그로 확인
    print("Saved filters: $selectedFiltersJson");
  }

  Future<List<CategoryList>> loadSelectedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    String? selectedFiltersJson = prefs.getString('selectedFilters');
    if (selectedFiltersJson != null) {
      List<dynamic> decodedFilters = jsonDecode(selectedFiltersJson);
      return decodedFilters
          .map((filterJson) => CategoryList.fromJson(filterJson))
          .toList();
    }
    return [];
  }

  void _fetchData() async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // SharedPreferences에서 최신 필터 정보 불러오기
    final String filtersString = prefs.getString('filters') ?? '[]';
    List<dynamic> filtersJson = jsonDecode(filtersString);
    List<Map<String, dynamic>> filters = filtersJson.map((filter) {
      return {"code": filter['code'], "number": filter['number']};
    }).toList();

    final String startDate = prefs.getString('startDate') ?? '';
    final String endDate = prefs.getString('endDate') ?? '';

    try {
      final SearchModel response = await SearchApi().searchPolicies(
        {
          "keyword": _controller.text,
          "list": filters,
          if (startDate.isNotEmpty) "startDate": startDate,
          if (endDate.isNotEmpty) "endDate": endDate,
        },
        _currentPage, // 페이지 번호 추가
      );

      setState(() {
        if (response.data?.content?.isEmpty ?? true) {
          _hasMore = false;
        } else {
          _currentPage++; // 다음 페이지 번호로 증가합니다.
          _filteredPolices
              .addAll(response.data!.content!); // 현재 페이지의 데이터를 추가합니다.
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _isFetching = false;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore) {
      // 추가 검색 결과를 가져올 수 있는지 여부를 확인합니다.
      _fetchData(); // 다음 페이지의 데이터를 불러옵니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasFilters = _selectedFilters.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '검색어를 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    _startListening();
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchListener();
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: _selectedFilters.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Wrap(
                spacing: 6.0,
                children: _selectedFilters
                    .map((filter) => Chip(
                          label: Text(filter.name ?? ''),
                          onDeleted: () {
                            _removeFilter(filter);
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _openFilterScreen, // 필터 화면을 여는 메서드 호출
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('필터',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.restart_alt_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text('전체해제',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('검색결과',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _filteredPolices.length,
              itemBuilder: (BuildContext context, int index) {
                final policy = _filteredPolices[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: ListTile(
                    title: Text(
                      policy.policyName ?? 'No name',
                      softWrap: true,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startListening() async {
    if (!_speech.isAvailable) {
      print('음성 입력 사용 불가능');
      return;
    }

    if (!_speech.isListening) {
      try {
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      } catch (e) {
        print('음성 입력 시작 중 오류 발생: $e');
      }
    } else {
      print('이미 음성 입력 중입니다.');
    }
  }

  void _removeFilter(CategoryList filter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 'filters' 목록에서 해당 필터 제거
    List<dynamic> filters = jsonDecode(prefs.getString('filters') ?? '[]');
    // 필터를 제대로 식별하기 위해 'code'와 'number' 모두 확인
    filters.removeWhere((item) =>
        item['code'] == filter.code &&
        item['number'].toString() == filter.number);
    await prefs.setString('filters', jsonEncode(filters));

    // 'selectedFilters' 목록에서 해당 필터 제거
    List<dynamic> selectedFilters =
        jsonDecode(prefs.getString('selectedFilters') ?? '[]');
    selectedFilters.removeWhere((item) =>
        item['code'] == filter.code &&
        item['number'].toString() == filter.number);
    await prefs.setString('selectedFilters', jsonEncode(selectedFilters));

    // UI 업데이트
    setState(() {
      _selectedFilters.removeWhere((selectedFilter) =>
          selectedFilter.code == filter.code &&
          selectedFilter.number == filter.number);
    });
  }

  void _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('filters');
    await prefs.remove('startDate');
    await prefs.remove('endDate');
    await prefs.remove('selectedFilters'); // 선택된 필터 목록도 초기화합니다.

    setState(() {
      _controller.text = '';
      _filteredPolices.clear();
      _selectedFilters.clear(); // 화면에서 선택된 필터 목록을 초기화합니다.
      _currentPage = 0;
      _hasMore = true;
    });

    await saveSelectedFilters(_selectedFilters); // 변경된 필터를 저장합니다.
    _searchListener(); // 모든 필터를 해제한 후 검색 결과를 초기화합니다.
  }

  void _updateFilters(List<CategoryList> returnedFilters) {
    setState(() {
      _selectedFilters.clear();
      _selectedFilters.addAll(returnedFilters);
    });
    Route createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FilterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    }

    _searchListener();
  }
}
