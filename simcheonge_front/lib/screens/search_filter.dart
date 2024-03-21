import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateFormat을 사용하기 위해 추가
import 'package:shared_preferences/shared_preferences.dart';

enum DateSelection { always, undecided, selectPeriod }

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<bool> isSelectedRegion = List.generate(18, (index) => false);
  List<bool> isSelectedEducation = List.generate(4, (index) => false);
  List<bool> isSelectedEmploymentStatus = List.generate(4, (index) => false);
  List<bool> isSelectedSpecialization = List.generate(4, (index) => false);
  List<bool> isSelectedInterest = List.generate(6, (index) => false);
  DateTime? startDate;
  DateTime? endDate;

  // 임시 날짜 변수 추가
  DateTime? tempStartDate;
  DateTime? tempEndDate;

  DateSelection dateSelection = DateSelection.always;
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 추가

  // 위젯이 메모리에서 해제될 때 호출
  @override
  void dispose() {
    _scrollController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  List<String> regionOptions = [
    '중앙부처',
    '서울',
    '부산',
    '대구',
    '인천',
    '광주',
    '대전',
    '울산',
    '경기',
    '강원',
    '충북',
    '충남',
    '전북',
    '전남',
    '경북',
    '경남',
    '제주',
    '세종'
  ];
  List<String> educationOptions = ['제한 없음', '고졸 이하', '대졸 이하', '석/박사'];
  List<String> employmentStatusOptions = ['제한 없음', '재직자', '개인 사업자', '미취업자'];
  List<String> specializationOptions = ['제한 없음', '여성', '장애인', '저소득층'];
  List<String> interestOptions = ['제한 없음', '일자리', '주거', '교육', '복지/문화', '참여/권리'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('필터')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildToggleButtons('지역', regionOptions, isSelectedRegion),
            buildToggleButtons('학력', educationOptions, isSelectedEducation),
            buildToggleButtons(
                '취업 상태', employmentStatusOptions, isSelectedEmploymentStatus),
            buildToggleButtons(
                '특화 분야', specializationOptions, isSelectedSpecialization),
            buildToggleButtons('관심 분야', interestOptions, isSelectedInterest),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('신청 기간',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            buildDateSelectionContent(), // 이동된 위치에 선택 기간 표시 위젯 추가
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
                  onPressed: resetFilters,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: saveFilters,
                  child: const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToggleButtons(
      String title, List<String> options, List<bool> isSelected) {
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
            children: List.generate(options.length, (index) {
              return ChoiceChip(
                label: Text(options[index]),
                selected: isSelected[index],
                selectedColor: Colors.blue.shade200,
                showCheckmark: false,
                onSelected: (bool selected) {
                  setState(() {
                    isSelected[index] = selected;
                  });
                },
              );
            }),
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
              });
              if (dateSelection == DateSelection.selectPeriod) {
                _showDateRangePickerModal();
              }
            },
            children: const <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('상시')),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('미정')),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('기간 선택')),
            ],
          ),
        ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '선택 기간: $formattedStartDate - $formattedEndDate',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
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

  void resetFilters() {
    setState(() {
      isSelectedRegion = List.generate(regionOptions.length, (index) => false);
      isSelectedEducation =
          List.generate(educationOptions.length, (index) => false);
      isSelectedEmploymentStatus =
          List.generate(employmentStatusOptions.length, (index) => false);
      isSelectedSpecialization =
          List.generate(specializationOptions.length, (index) => false);
      isSelectedInterest =
          List.generate(interestOptions.length, (index) => false);
      startDate = null;
      endDate = null;
      dateSelection =
          DateSelection.always; // Set date selection back to 'always'
      tempStartDate = null; // Clear temporary start date
      tempEndDate = null; // Clear temporary end date
    });
  }

  Future<void> saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    // 필터 상태를 저장하는 로직...

    setState(() {
      // tempStartDate와 tempEndDate에서 선택한 값을 실제 startDate와 endDate에 할당합니다.
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
  // buildDateSelection과 buildDateSelectionContent 메서드는 기존 로직을 유지하되,
  // 실제 날짜 변수가 아닌 임시 날짜 변수를 사용하는 부분만 변경해 주세요.
}
