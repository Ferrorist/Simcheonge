import 'package:flutter/material.dart';
import 'package:simcheonge_front/services/post_service.dart';
import 'package:simcheonge_front/widgets/comment_widget.dart';
import 'package:intl/intl.dart'; // DateFormat 사용을 위해 추가

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // 앱바 높이 조절
        child: AppBar(
          title: FutureBuilder<Map<String, dynamic>>(
            future: PostService.fetchPostDetail(postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final post = snapshot.data!;
                final String formattedDate =
                    post['createdAt']?.substring(0, 10) ?? '날짜 정보 없음';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end, // 아이템을 아래쪽으로 정렬
                  children: <Widget>[
                    Row(
                      // 윗줄
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            post['postName'] ?? '제목 없음',
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.bookmark_outline),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.edit), onPressed: () {}),
                      ],
                    ),
                    Row(
                      // 아랫줄
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(post['categoryName'] ?? '카테고리 없음'),
                        Text(formattedDate),
                      ],
                    ),
                  ],
                );
              } else {
                return const Text('게시글 상세');
              }
            },
          ),
          actions: const <Widget>[],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: PostService.fetchPostDetail(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final post = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['postContent'] ?? '내용 없음',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      CommentWidget(postId: postId), // 댓글 위젯 추가
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
