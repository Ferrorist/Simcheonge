import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';
import 'package:simcheonge_front/widgets/bookmark_detail.dart';

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
    if (_isBookmarked) {
      if (_bookmarkId != null) {
        await _bookmarkService.deleteBookmark(_bookmarkId!);
      }
    } else {
      await _bookmarkService.createBookmark(
        widget.bookmarkType,
        policyId: widget.policyId,
        postId: widget.postId,
      );
      // 북마크 생성 후 ID 업데이트 필요. 실제 구현에서 서버로부터 북마크 ID를 받아와야 함.
    }

    setState(() {
      _isBookmarked = !_isBookmarked;
      // 북마크 삭제 후 _bookmarkId 초기화 필요
      if (_isBookmarked == false) {
        _bookmarkId = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      onPressed: () async {
        final isLoggedIn = await _checkLoginStatus();
        if (isLoggedIn) {
          // 로그인 상태일 때만 북마크 상태 확인 및 토글
          _checkBookmarkStatus();
          _toggleBookmark();
        } else {
          // 로그인 페이지로 이동하거나 로그인이 필요하다는 알림 표시
          // 예: Navigator.pushNamed(context, '/login');
        }
      },
    );
  }
}
