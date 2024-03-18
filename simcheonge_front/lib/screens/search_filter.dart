import 'package:flutter/material.dart';
import 'package:simcheonge_front/widgets/custom_dropdown.dart'; // CustDropDown 정의된 경로에 맞게 수정
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedRegion;
  String? selectedEducation;
  String? selectedEmploymentStatus;
  String? selectedSpecialization;
  String? selectedInterest;
  DateTime? startDate;
  DateTime? endDate;

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
            buildDropdownTile('지역', regionOptions, selectedRegion,
                (String? value) {
              setState(() => selectedRegion = value);
            }, maxHeight: 200),
            buildDropdownTile('학력', educationOptions, selectedEducation,
                (String? value) {
              setState(() => selectedEducation = value);
            }),
            buildDropdownTile(
                '취업 상태', employmentStatusOptions, selectedEmploymentStatus,
                (String? value) {
              setState(() => selectedEmploymentStatus = value);
            }),
            buildDropdownTile(
                '특화 분야', specializationOptions, selectedSpecialization,
                (String? value) {
              setState(() => selectedSpecialization = value);
            }),
            buildDropdownTile('관심 분야', interestOptions, selectedInterest,
                (String? value) {
              setState(() => selectedInterest = value);
            }),
            buildDateSelectionTile(),
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

  Widget buildDropdownTile(String title, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged,
      {double? maxHeight}) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 5),
        child: CustDropDown<String>(
          items: options
              .map((String value) => CustDropdownMenuItem<String>(
                  value: value, child: Text(value)))
              .toList(),
          onChanged: onChanged,
          hintText: '선택하세요',
          defaultSelectedIndex: options.indexOf(selectedValue ?? ''),
          enabled: true,
          borderRadius: 12,
          maxListHeight: maxHeight ?? 150,
          borderWidth: 1,
        ),
      ),
    );
  }

  Widget buildDateSelectionTile() {
    return ListTile(
      title: const Text('기간 선택',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => selectDate(context, isStart: true),
              child: Text(
                startDate == null
                    ? '시작 날짜'
                    : '${startDate!.year}/${startDate!.month}/${startDate!.day}',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () => selectDate(context, isStart: false),
              child: Text(
                endDate == null
                    ? '종료 날짜'
                    : '${endDate!.year}/${endDate!.month}/${endDate!.day}',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectDate(BuildContext context, {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void resetFilters() {
    setState(() {
      selectedRegion = null;
      selectedEducation = null;
      selectedEmploymentStatus = null;
      selectedSpecialization = null;
      selectedInterest = null;
      startDate = null;
      endDate = null;
    });
  }

  Future<void> saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRegion', selectedRegion ?? '');
    await prefs.setString('selectedEducation', selectedEducation ?? '');
    await prefs.setString(
        'selectedEmploymentStatus', selectedEmploymentStatus ?? '');
    await prefs.setString(
        'selectedSpecialization', selectedSpecialization ?? '');
    await prefs.setString('selectedInterest', selectedInterest ?? '');
    if (startDate != null) {
      await prefs.setString('startDate', startDate!.toIso8601String());
    }
    if (endDate != null) {
      await prefs.setString('endDate', endDate!.toIso8601String());
    }
    Navigator.pop(context);
  }
}
