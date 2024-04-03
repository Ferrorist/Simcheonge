import 'package:flutter/material.dart';
import 'package:simcheonge_front/models/bookmark_detail.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';

class BookmarkPolicyScreen extends StatefulWidget {
  const BookmarkPolicyScreen({super.key});

  @override
  State<BookmarkPolicyScreen> createState() => _BookmarkPolicyScreenState();
}

class _BookmarkPolicyScreenState extends State<BookmarkPolicyScreen> {
  List<Bookmark> bookmarkedItems = [];
  bool _isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedItems();
  }

  Future<void> _fetchBookmarkedItems() async {
    try {
      setState(() {
        _isLoading = true; // 데이터 로딩 시작
      });
      final bookmarks = await BookmarkService()
          .getBookmarks('POL'); // 'POL'이나 'POS'에 따라 북마크를 가져옵니다.
      setState(() {
        bookmarkedItems = bookmarks;
        _isLoading = false; // 데이터 로딩 완료
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // 에러 발생 시 로딩 상태 해제
      });
      print('북마크를 가져오는 데 실패했습니다: $e');
    }
  }

  void _removeBookmark(int bookmarkId, int index) async {
    try {
      await BookmarkService().deleteBookmark(bookmarkId);
      setState(() {
        bookmarkedItems.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('북마크가 삭제되었습니다.'),
      ));
    } catch (e) {
      print('북마크 삭제 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('북마크 삭제에 실패했습니다.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 북마크'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 인디케이터 표시
          : ListView.builder(
              itemCount: bookmarkedItems.length,
              itemBuilder: (context, index) {
                final item = bookmarkedItems[index];
                String title = item.bookmarkType == 'POL'
                    ? item.policyName ?? '정책 이름 없음'
                    : item.postName ?? '게시물 이름 없음';
                return ListTile(
                  title: Text(title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeBookmark(item.bookmarkId, index),
                  ),
                );
              },
            ),
    );
  }
}
