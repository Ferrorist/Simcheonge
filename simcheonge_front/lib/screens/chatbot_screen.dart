import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'ChatbotScreen',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
