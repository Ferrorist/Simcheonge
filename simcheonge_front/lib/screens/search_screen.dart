import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:simcheonge_front/screens/search_filter.dart';
import 'dart:ui';
import 'package:simcheonge_front/models/search_model.dart';
import 'package:simcheonge_front/services/search_api.dart';

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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_searchListener);
    _scrollController.addListener(_scrollListener);
    _fetchData(); // 초기 데이터 로드
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore) {
      _fetchData();
    }
  }

  void _searchListener() {
    _filteredPolices.clear();
    _currentPage = 0;
    _hasMore = true;
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;

    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences에서 필터 목록과 날짜 범위를 불러옵니다.
    final String filtersString = prefs.getString('filters') ?? '[]';
    List<Map<String, dynamic>> filters =
        List<Map<String, dynamic>>.from(json.decode(filtersString));

    final String startDate = prefs.getString('startDate') ?? '';
    final String endDate = prefs.getString('endDate') ?? '';

    try {
      final SearchModel response = await SearchApi().searchPolicies(
        _controller.text, // 검색어
        filters, // 필터 목록
        startDate: startDate, // 시작 날짜 (이름 있는 인자로 전달)
        endDate: endDate, // 종료 날짜 (이름 있는 인자로 전달)
      );

      // API 응답에서 List<Content>를 올바르게 추출
      final List<Content> newData = response.data?.content ?? [];

      setState(() {
        if (newData.isEmpty) {
          _hasMore = false;
        } else {
          _currentPage++;
          _filteredPolices.addAll(newData); // 올바른 타입의 데이터 추가
        }
      });
    } catch (e) {
      print(e); // 에러 처리
    } finally {
      _isFetching = false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    // 음성 검색 기능 구현 필요
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
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('필터',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    title: Text(
                      policy.policyName ?? 'No name', // 'policyName'은 모델에 따라 다름
                      style: const TextStyle(fontSize: 19),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // 아이템 클릭 시 수행할 작업
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
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
}
