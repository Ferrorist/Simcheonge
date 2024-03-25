import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/filter_model.dart';
import 'package:simcheonge_front/services/filter_api.dart';

enum DateSelection { always, undecided, selectPeriod }

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Map<String, bool> regionSelections = {};
  Map<String, bool> educationSelections = {};
  Map<String, bool> employmentStatusSelections = {};
  Map<String, bool> specializationSelections = {};
  Map<String, bool> interestSelections = {};
  DateTime? startDate;
  DateTime? endDate;

  DateTime? tempStartDate;
  DateTime? tempEndDate;

  DateSelection dateSelection = DateSelection.always;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<String> regionOptions = [];
  List<String> educationOptions = [];
  List<String> employmentStatusOptions = [];
  List<String> specializationOptions = [];
  List<String> interestOptions = [];

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
  }

  Future<void> _loadFilterOptions() async {
    try {
      final filterModel = await FilterApi.fetchFilters();
      setState(() {
        regionOptions = _extractNames(filterModel, 'RGO');
        educationOptions = _extractNames(filterModel, 'ADM');
        employmentStatusOptions = _extractNames(filterModel, 'EPM');
        specializationOptions = _extractNames(filterModel, 'SPC');
        interestOptions = _extractNames(filterModel, 'PFD');
        regionSelections = _initializeSelections(regionOptions);
        educationSelections = _initializeSelections(educationOptions);
        employmentStatusSelections =
            _initializeSelections(employmentStatusOptions);
        specializationSelections = _initializeSelections(specializationOptions);
        interestSelections = _initializeSelections(interestOptions);
      });
    } catch (e) {
      debugPrint("Failed to load filter options: $e");
    }
  }

  List<String> _extractNames(FilterModel filterModel, String tag) {
    return filterModel.data
            ?.firstWhere((d) => d.tag == tag, orElse: () => Data())
            .categoryList
            ?.map((e) => e.name ?? '')
            .toList() ??
        [];
  }

  Map<String, bool> _initializeSelections(List<String> options) {
    return {for (var option in options) option: false};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('필터'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildToggleButtons('지역', regionOptions, regionSelections),
            _buildToggleButtons('학력', educationOptions, educationSelections),
            _buildToggleButtons(
                '취업 상태', employmentStatusOptions, employmentStatusSelections),
            _buildToggleButtons(
                '특화 분야', specializationOptions, specializationSelections),
            _buildToggleButtons('관심 분야', interestOptions, interestSelections),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('신청 기간',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            buildDateSelectionContent(),
            buildDateSelection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.replay_outlined),
                  label: const Text('초기화'),
                  onPressed: _resetFilters,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveFilters,
                  child: const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateSelectionContent() {
    if (dateSelection != DateSelection.selectPeriod ||
        startDate == null ||
        endDate == null) {
      return Container(); // 선택한 날짜 범위가 없으면 아무것도 표시하지 않음
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedStartDate = formatter.format(startDate!);
    final String formattedEndDate = formatter.format(endDate!);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택 기간: $formattedStartDate - $formattedEndDate',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildDateSelection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToggleButtons(
            borderRadius: BorderRadius.circular(8),
            isSelected: [
              dateSelection == DateSelection.always,
              dateSelection == DateSelection.undecided,
              dateSelection == DateSelection.selectPeriod,
            ],
            onPressed: (int index) {
              setState(() {
                dateSelection = DateSelection.values[index];
                if (dateSelection == DateSelection.selectPeriod) {
                  _showDateRangePickerModal();
                } else {
                  // 기간 선택이 아닌 다른 옵션을 선택했을 때 tempStartDate와 tempEndDate를 null로 설정
                  tempStartDate = null;
                  tempEndDate = null;
                }
              });
            },
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('상시'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('미정'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('기간 선택'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(
      String title, List<String> options, Map<String, bool> selections) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Wrap(
            spacing: 8.0,
            children: options.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: selections[option] ?? false,
                selectedColor: Colors.blue.shade200,
                showCheckmark: false,
                onSelected: (bool selected) {
                  setState(() {
                    selections[option] = selected;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showDateRangePickerModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("기간 선택"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempStartDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                        helpText: "시작 날짜 선택",
                      );
                      if (picked != null) {
                        setState(() {
                          tempStartDate = picked;
                          if (tempEndDate != null &&
                              tempEndDate!.isBefore(picked)) {
                            tempEndDate = picked;
                          }
                        });
                      }
                    },
                    child: Text(tempStartDate == null
                        ? "시작 날짜 선택"
                        : "시작 날짜: ${DateFormat('yyyy-MM-dd').format(tempStartDate!)}"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempEndDate ??
                            (tempStartDate ?? DateTime.now())
                                .add(const Duration(days: 1)),
                        firstDate: tempStartDate ?? DateTime.now(),
                        lastDate: DateTime(2025),
                        helpText: "종료 날짜 선택",
                      );
                      if (picked != null) {
                        setState(() {
                          tempEndDate = picked;
                        });
                      }
                    },
                    child: Text(tempEndDate == null
                        ? "종료 날짜 선택"
                        : "종료 날짜: ${DateFormat('yyyy-MM-dd').format(tempEndDate!)}"),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // 취소 버튼을 누르면 상시 선택으로 변경
                    setState(() {
                      dateSelection = DateSelection.always;
                    });
                  },
                ),
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    if (tempStartDate != null && tempEndDate != null) {
                      setState(() {
                        // 확인 버튼을 눌렀을 때 선택한 날짜를 실제 변수에 할당하고 선택 기간을 표시
                        startDate = tempStartDate;
                        endDate = tempEndDate;
                        dateSelection = DateSelection.selectPeriod;
                        // 변경사항 즉시 적용
                        tempStartDate = startDate;
                        tempEndDate = endDate;
                      });
                      Navigator.of(context).pop(); // 모달 닫기
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // 모달이 닫힌 후 선택한 기간이 필터 스크린에 바로 표시되도록 setState 호출
      setState(() {});
    });
  }

  void _resetFilters() {
    setState(() {
      regionSelections = _initializeSelections(regionOptions);
      educationSelections = _initializeSelections(educationOptions);
      employmentStatusSelections =
          _initializeSelections(employmentStatusOptions);
      specializationSelections = _initializeSelections(specializationOptions);
      interestSelections = _initializeSelections(interestOptions);
      dateSelection = DateSelection.always;
      tempStartDate = null;
      tempEndDate = null;
    });
  }

  Future<void> _saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
// 필터 상태를 저장하는 로직...
    setState(() {
      startDate = tempStartDate;
      endDate = tempEndDate;
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }
}
