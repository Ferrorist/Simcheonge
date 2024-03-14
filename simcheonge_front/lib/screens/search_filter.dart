import 'package:flutter/material.dart';
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

  // 옵션 목록
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
      appBar: AppBar(
        title: const Text('필터'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // 여기에 마진 추가
            buildDropdownTile('지역', regionOptions, selectedRegion,
                (String? value) {
              setState(() => selectedRegion = value);
            }, 7),
            const SizedBox(height: 10), // 여기에 마진 추가
            buildDropdownTile('학력', educationOptions, selectedEducation,
                (String? value) {
              setState(() => selectedEducation = value);
            }),
            const SizedBox(height: 10), // 여기에 마진 추가
            buildDropdownTile(
                '취업 상태', employmentStatusOptions, selectedEmploymentStatus,
                (String? value) {
              setState(() => selectedEmploymentStatus = value);
            }),
            const SizedBox(height: 10), // 여기에 마진 추가
            buildDropdownTile(
                '특화 분야', specializationOptions, selectedSpecialization,
                (String? value) {
              setState(() => selectedSpecialization = value);
            }),
            const SizedBox(height: 10), // 여기에 마진 추가
            buildDropdownTile('관심 분야', interestOptions, selectedInterest,
                (String? value) {
              setState(() => selectedInterest = value);
            }),
            const SizedBox(height: 10), // 여기에 마진 추가
            buildDateSelectionTile(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.replay_outlined),
                  label: const Text('초기화'),
                  onPressed: () => resetFilters(),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => saveFilters(),
                  child: const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildDropdownTile(String title, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged,
      [int? maxShow]) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 19,
        ),
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            hint: const Text('선택하세요'),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            menuMaxHeight: maxShow != null ? 200.0 : null,
          ),
        ),
      ),
    );
  }

  ListTile buildDateSelectionTile() {
    return ListTile(
      title: const Text(
        '기간 선택',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
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
