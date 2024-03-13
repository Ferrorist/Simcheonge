import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: const Text('뉴스 페이지 입니다.'),
        ),
      ),
    );
  }
}
