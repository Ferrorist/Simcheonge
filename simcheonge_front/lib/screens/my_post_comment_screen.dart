import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/screens/post_detail_screen.dart';
import 'dart:convert';
import 'package:simcheonge_front/widgets/side_app_bar.dart';

// 가정: MyComment 모델
class MyComment {
  final int commentId;
  final String commentType;
  final int referencedId;
  final String content;
  final String createdAt;

  MyComment({
    required this.commentId,
    required this.commentType,
    required this.referencedId,
    required this.content,
    required this.createdAt,
  });

  factory MyComment.fromJson(Map<String, dynamic> json) {
    return MyComment(
      commentId: json['commentId'],
      commentType: json['commentType'],
      referencedId: json['referencedId'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}

class MyPostCommentScreen extends StatefulWidget {
  const MyPostCommentScreen({super.key});

  @override
  _MyPostCommentScreenState createState() => _MyPostCommentScreenState();
}

class _MyPostCommentScreenState extends State<MyPostCommentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  List<MyComment> allComments = [];
  List<MyComment> displayedComments = [];

  @override
  void initState() {
    super.initState();
    _fetchMyComments();
    _controller.addListener(() {
      updateSearchQuery(_controller.text);
    });
  }

  Future<void> _fetchMyComments() async {
    // 가정: 댓글 데이터를 불러오는 서버의 URL
    final response =
        await http.get(Uri.parse('https://j10e102.p.ssafy.io/api/comment/POS'));

    if (response.statusCode == 200) {
      final List<dynamic> commentsJson = json.decode(response.body);
      setState(() {
        allComments =
            commentsJson.map((json) => MyComment.fromJson(json)).toList();
        displayedComments = allComments;
      });
    } else {
      // 오류 처리
      print('Failed to load comments');
    }
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      displayedComments = allComments
          .where((comment) =>
              comment.content.toLowerCase().contains(newQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '검색...',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _controller.clear(),
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: displayedComments.length,
        itemBuilder: (context, index) {
          final comment = displayedComments[index];
          return ListTile(
            title: Text(comment.content),
            onTap: () {
              // 가정: 댓글이 달린 게시물의 상세 화면으로 이동
              // 여기에서는 이동 로직을 구현하지만, 실제로는 프로젝트의 라우팅 설정에 따라 다름
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostDetailScreen(postId: comment.referencedId)),
              );
            },
          );
        },
      ),
    );
  }
}
