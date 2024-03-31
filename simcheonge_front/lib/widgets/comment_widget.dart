import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentWidget extends StatefulWidget {
  final int postId;

  const CommentWidget({super.key, required this.postId});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  List<dynamic> _comments = []; // 변수명을 _Comment에서 _comments로 변경하여 의미를 명확하게 함

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse(
        'https://j10e102.p.ssafy.io/api/comment/POS/${widget.postId}');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      setState(() {
        _comments = json.decode(response.body)['data'];
      });
    } else {
      print('Failed to load comments: ${response.body}');
    }
  }

  Future<void> _addComment(String content) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse('https://j10e102.p.ssafy.io/api/comment');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'commentType': 'POS',
          'referencedId': widget.postId,
          'content': content,
        }));

    if (response.statusCode == 200) {
      print('Comment added successfully');
      _commentController.clear();
      _fetchComments();
    } else {
      print('Failed to add comment: ${response.body}');
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse('https://j10e102.p.ssafy.io/api/comment/$commentId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      print('Comment deleted successfully');
      _fetchComments();
    } else {
      print('Failed to delete comment: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('댓글'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  title: Text(comment['nickname']),
                  subtitle: Text(comment['content']),
                  trailing: comment['isMyComment']
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteComment(comment['id']),
                        )
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '댓글 추가...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _addComment(_commentController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
