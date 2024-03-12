import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'NewsScreen',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
