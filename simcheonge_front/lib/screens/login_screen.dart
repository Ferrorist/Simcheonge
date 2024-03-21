import 'package:flutter/material.dart';
import 'package:simcheonge_front/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController를 사용하여 텍스트 필드 입력 값을 관리합니다.
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            // ID 입력 필드
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: '아이디를 입력하세요',
              ),
            ),
            const SizedBox(height: 10), // 입력 필드 간의 여백
            // 비밀번호 입력 필드
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'PW',
                hintText: '비밀번호를 입력하세요',
              ),
              obscureText: true, // 비밀번호를 숨김 처리
            ),
            const SizedBox(height: 20),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                // 로그인 로직 구현
              },
              child: const Text('로그인'),
            ),
            const SizedBox(height: 10),
            // 회원가입 텍스트 버튼
            TextButton(
              onPressed: () {
                // 회원가입 화면으로 넘어가는 로직 구현
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
    // 컨트롤러 사용 후 자원 해제
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
