import 'package:flutter/material.dart';
import 'package:simcheonge_front/widgets/main_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 앱바가 이쁘게 자리 잡게 화면 틀을 잡아준다.
      child: Scaffold(
        appBar: const PreferredSize(
          // AppBar 클래스는 명시적으로 너비와 높이를 설정할 수 있는 PreferredSize 위젯을 상속 받는다.
          preferredSize: Size.fromHeight(70), // 앱바 높이 조절
          child: MainAppBar(), // 앱바 적용
        ),
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // 버튼을 눌렀을 때, 서브 페이지로 이동하는 기능 구현
            },
            child: const Text('서브 페이지로 이동'),
          ),
        ),
      ),
    );
  }
}
