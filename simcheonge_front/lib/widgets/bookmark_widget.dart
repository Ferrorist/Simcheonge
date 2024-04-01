import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';
import 'package:simcheonge_front/widgets/bookmark_detail.dart';
// BookmarkService와 Bookmark 모델을 적절히 임포트해야 합니다.

class BookmarkWidget extends StatefulWidget {
  final String bookmarkType; // "POL" 또는 "POS"
  final int? policyId;
  final int? postId;

  const BookmarkWidget({
    super.key,
    required this.bookmarkType,
    this.policyId,
    this.postId,
  });

  @override
  State<BookmarkWidget> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  final BookmarkService _bookmarkService = BookmarkService();
  bool _isBookmarked = false;
  int? _bookmarkId; // 북마크 ID

  @override
  void initState() {
    super.initState();
    _checkLoginStatus().then((isLoggedIn) {
      if (isLoggedIn) {
        _checkBookmarkStatus();
      }
    });
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    return accessToken != null;
  }

  void _checkBookmarkStatus() async {
    try {
      int? referenceId =
          widget.bookmarkType == 'POL' ? widget.policyId : widget.postId;
      if (referenceId == null) {
        setState(() {
          _isBookmarked = false;
        });
        return;
      }

      final List<Bookmark> bookmarks =
          await _bookmarkService.getBookmarks(widget.bookmarkType);
      final Bookmark currentBookmark = bookmarks.firstWhere(
        (bookmark) =>
            (widget.bookmarkType == 'POL'
                ? bookmark.policyId
                : bookmark.postId) ==
            referenceId,
        // orElse: () => null,
      );

      setState(() {
        _isBookmarked =
            currentBookmark != null; // True if a currentBookmark exists
        _bookmarkId = currentBookmark
            .bookmarkId; // Safely access bookmarkId, which may be null
      });
    } catch (e) {
      print('Error checking bookmark status: $e');
      setState(() {
        _isBookmarked = false;
        _bookmarkId = null;
      });
    }
  }

  void _toggleBookmark() async {
    print("북마크 상태 변경 전: $_isBookmarked");

    if (_isBookmarked) {
      // 북마크 삭제 로직
      if (_bookmarkId != null) {
        await _bookmarkService.deleteBookmark(_bookmarkId!);
      }
    } else {
      // 북마크 추가 로직
      await _bookmarkService.createBookmark(
        widget.bookmarkType,
        policyId: widget.policyId,
        postId: widget.postId,
      );
      // 북마크 생성 후 ID 업데이트 필요. 실제 구현에서 서버로부터 북마크 ID를 받아와야 함.
    }

    setState(() {
      _isBookmarked = !_isBookmarked;
      if (!_isBookmarked) {
        _bookmarkId = null; // 북마크 삭제 후 _bookmarkId 초기화
      }
    });

    print("북마크 상태 변경 후: $_isBookmarked");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? '북마크에 추가되었습니다.' : '북마크에서 제거되었습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      color: _isBookmarked ? Colors.yellow : null, // 북마크 상태에 따라 아이콘 색상 변경
      onPressed: () async {
        try {
          final isLoggedIn = await _checkLoginStatus();
          if (isLoggedIn) {
            _toggleBookmark();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('로그인이 필요합니다.')),
            );
          }
        } catch (e) {
          print("북마크 처리 중 에러 발생: $e");
        }
      },
    );
  }
}
