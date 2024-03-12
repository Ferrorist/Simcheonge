import 'package:flutter/material.dart';
import 'package:simcheonge_front/widgets/sub_app_bar.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70), // 앱바 높이 조절
          child: SubAppBar(),
        ),
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
