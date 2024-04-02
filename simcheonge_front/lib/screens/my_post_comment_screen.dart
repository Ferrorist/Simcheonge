import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  final int commentId;
  final String nickname;
  final String content;
  final String createdAt;
  final bool isMyComment;

  Comment({
    required this.commentId,
    required this.nickname,
    required this.content,
    required this.createdAt,
    required this.isMyComment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] as int,
      nickname: json['nickname'] as String,
      content: json['content'] as String,
      createdAt: json['createAt'] as String,
      isMyComment: json['myComment'] as bool,
    );
  }
}

class MyPostCommentScreen extends StatefulWidget {
  const MyPostCommentScreen({super.key});

  @override
  _MyPostCommentScreenState createState() => _MyPostCommentScreenState();
}

class _MyPostCommentScreenState extends State<MyPostCommentScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    // URL 수정 필요: 실제 댓글 데이터를 불러오는 URL로 변경하세요
    final response =
        await http.get(Uri.parse('https://j10e102.p.ssafy.io/api/comments'));

    if (response.statusCode == 200) {
      List<dynamic> commentsJson = json.decode(response.body);
      setState(() {
        comments = commentsJson.map((json) => Comment.fromJson(json)).toList();
      });
      print('댓글 데이터 로드 성공');
    } else {
      print('댓글 데이터 로드 실패: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 댓글 목록')),
      body: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return ListTile(
            title: Text(comment.nickname),
            subtitle: Text('${comment.content}\n${comment.createdAt}'),
            isThreeLine: true,
            onTap: () {
              // 게시글 상세 화면으로 이동하는 로직 추가 (예시)
              print('댓글 ${comment.commentId}의 게시글로 이동');
            },
          );
        },
      ),
    );
  }
}
