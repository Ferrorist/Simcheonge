import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'ArticleScreen',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
