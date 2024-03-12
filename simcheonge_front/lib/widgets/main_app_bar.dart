import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          //앱바와 페이지의 구분을 주기 위해 BoxShadow로 그림자 만들어서 사용.
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        child: const Text(
          '메인 페이지 앱바',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
