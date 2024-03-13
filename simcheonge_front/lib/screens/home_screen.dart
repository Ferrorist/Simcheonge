import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 앱바가 이쁘게 자리 잡게 화면 틀을 잡아준다.
      child: Scaffold(
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
