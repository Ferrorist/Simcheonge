import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: const Text('챗봇 페이지 입니다.'),
        ),
      ),
    );
  }
}
