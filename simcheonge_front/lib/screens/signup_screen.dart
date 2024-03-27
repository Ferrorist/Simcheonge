import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
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

    final url = Uri.parse('https://j10e102.p.ssafy.io/api/users/signup');
    final requestData = jsonEncode({
      'userNickname': _nicknameController.text,
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
        // 회원가입 성공 시 로그인 상태 저장 및 홈 화면으로 이동
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage()), // 가정: 로그인 성공 후 이동할 화면
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('회원가입에 실패했습니다: ${json.decode(response.body)}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입에 실패했습니다: $e')),
      );
    }
  }

  Future<void> checkNickname() async {
    final url = Uri.parse(
        'https://j10e102.p.ssafy.io/api/users/check-nickname/${_nicknameController.text}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("사용 가능한 닉네임입니다.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 사용중인 닉네임이거나 조회에 실패했습니다.")));
      }
    } catch (e) {
      developer.log('닉네임 중복 검사 중 오류 발생', error: e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("닉네임 중복 검사 중 오류가 발생했습니다: $e")));
    }
  }

  Future<void> checkLoginId() async {
    final url = Uri.parse(
        'https://j10e102.p.ssafy.io/api/users/check-loginId/${_idController.text}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("사용 가능한 ID입니다.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 사용중인 ID이거나 조회에 실패했습니다.")));
      }
    } catch (e) {
      developer.log('ID 중복 검사 중 오류 발생', error: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ID 중복 검사 중 오류가 발생했습니다: ${e.toString()}")));
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
            buildTextField(_nicknameController, '닉네임',
                '2~8자 한글/영문/한글+숫자/영문+숫자/한글+영문', checkNickname),
            buildTextField(_idController, 'ID', '6~10자 영문/영문+숫자', checkLoginId),
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

  Widget buildTextField(TextEditingController controller, String label,
      String hint, Function() onTap) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onTap,
          child: const Text('중복 확인'),
        ),
      ],
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
