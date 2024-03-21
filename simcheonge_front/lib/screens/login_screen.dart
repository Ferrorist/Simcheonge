import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/screens/board_screen.dart';
import 'dart:convert';
import 'package:simcheonge_front/screens/signup_screen.dart';
import 'package:simcheonge_front/screens/home_screen.dart'; // 가정: 로그인 성공 후 이동할 화면

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    final url = Uri.parse('https://j10e102.p.ssafy.io/api/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userLoginId': _idController.text,
        'userPassword': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // 로그인 성공 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인에 성공했습니다.')),
      );
      // 로그인 성공 시 홈 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const BoardScreen()), // 가정: 로그인 성공 후 이동할 화면
      );
    } else {
      // 로그인 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인에 실패했습니다: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: '아이디를 입력하세요',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'PW',
                hintText: '비밀번호를 입력하세요',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login, // 로그인 함수를 버튼 클릭 이벤트에 연결
              child: const Text('로그인'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
