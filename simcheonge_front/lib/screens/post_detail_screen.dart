import 'package:flutter/material.dart';
import 'package:simcheonge_front/services/post_service.dart';
import 'package:simcheonge_front/widgets/bookmark_widget.dart'; // 서비스 경로는 예시로 사용

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 상세'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: PostService.fetchPostDetail(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final post = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              post['categoryName'] ?? '카테고리 없음',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.blue.shade800),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            // BookmarkWidget(
                            //   bookmarkType: 'POS', // 'POS' 타입으로 북마크 위젯 설정
                            //   postId: postId, // 현재 게시물 ID 전달
                            // );
                            // 북마크 로직 구현
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // 게시글 수정 로직 구현
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        post['postName'] ?? '제목 없음',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '작성일: ${post['createdAt'].substring(0, 10)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        post['postContent'] ?? '내용 없음',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    // 여기에 추가 UI 요소를 배치할 수 있습니다.
                    // CommentWidget(postId: postId), // 댓글 위젯 주석 처리
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('데이터 로딩 중 에러가 발생했습니다.'));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
