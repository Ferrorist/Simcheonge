import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  Future<void> signUp() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    final url = Uri.parse('https://j10e102.p.ssafy.io/api/user/signup');
    final requestData = jsonEncode({
      'usernickname': _nicknameController.text,
      'userLoginId': _idController.text,
      'userPassword': _passwordController.text,
      'userPasswordCheck': _passwordConfirmController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입에 성공했습니다.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입에 실패했습니다: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입에 실패했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
                hintText: '2~8자 한글/영문/한글+숫자/영문+숫자/한글+영문',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: '6~10자 영문/영문+숫자',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                hintText: '8~16자 영문/숫자/영문+숫자',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordConfirmController,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                hintText: '비밀번호를 다시 한번 입력하세요',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUp,
              child: const Text('가입 완료'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}
