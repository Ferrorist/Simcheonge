import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  DateSelection dateSelection = DateSelection.always;

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
  void initState() {
    super.initState();
  }

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
            buildDateSelection(),
            buildDateSelectionContent(),
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
          const Text('신청 기간',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
    // If 'selectPeriod' is not selected, nothing to show
    if (dateSelection != DateSelection.selectPeriod) return Container();

    // Otherwise, return the DateRangePicker
    return SfDateRangePicker(
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (args.value is PickerDateRange) {
          final PickerDateRange range = args.value;
          setState(() {
            startDate = range.startDate;
            endDate = range.endDate;
          });
        }
      },
      selectionMode: DateRangePickerSelectionMode.range,
      initialSelectedRange: startDate != null && endDate != null
          ? PickerDateRange(startDate!, endDate!)
          : null,
    );
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
      dateSelection = DateSelection.always; // Reset to 'always'
    });
  }

  Future<void> saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    // Save the selected regions
    List<String> selectedRegions = isSelectedRegion
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => regionOptions[entry.key])
        .toList();
    await prefs.setStringList('selectedRegions', selectedRegions);
    // Save other filters as needed...
    // Save the date range
    if (startDate != null && endDate != null) {
      await prefs.setString('startDate', startDate!.toIso8601String());
      await prefs.setString('endDate', endDate!.toIso8601String());
    }
    // Navigate back or show a confirmation message
    Navigator.pop(context);
  }
}
