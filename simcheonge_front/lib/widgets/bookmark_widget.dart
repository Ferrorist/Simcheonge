import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/bookmark_detail.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';

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
  bool _isBookmarked = false;
  int? _bookmarkId;

  @override
  void initState() {
    super.initState();
    print('여기여기');
    _checkLoginStatus().then((isLoggedIn) {
      if (isLoggedIn) {
        _checkBookmarkStatus();
      }
    });
  }

  Future<bool> _checkLoginStatus() async {
    print('체크중');

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') != null;
  }

  Future<void> _checkBookmarkStatus() async {
    final isLoggedIn = await _checkLoginStatus();
    print('체크중');
    if (!isLoggedIn) {
      print('User is not logged in');
      return;
    }

    try {
      final bookmarks =
          await BookmarkService().getBookmarks(widget.bookmarkType);
      Bookmark? bookmark = bookmarks.firstWhere(
        (b) => widget.bookmarkType == 'POL'
            ? b.policyId == widget.policyId
            : b.postId == widget.postId,
      );

      setState(() {
        _isBookmarked = bookmark != null;
        _bookmarkId = bookmark.bookmarkId;
      });
    } catch (e) {
      print('Failed to check bookmark status: $e');
      setState(() {
        _isBookmarked = false;
        _bookmarkId = null;
      });
    }
  }

  void _toggleBookmark() async {
    print('Toggle Bookmark Button Pressed'); // 버튼이 눌렸는지 확인
    final isLoggedIn = await _checkLoginStatus();
    print('Is Logged In: $isLoggedIn'); // 로그인 상태 확인 로그

    if (!isLoggedIn) {
      print('User is not logged in'); // 로그인 상태 로그
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    if (_isBookmarked) {
      // 북마크 삭제 로직
      print('Attempting to delete bookmark, ID: $_bookmarkId'); // 삭제 시도 로그
      if (_bookmarkId != null) {
        try {
          await BookmarkService().deleteBookmark(_bookmarkId!);
          print('Bookmark deleted successfully'); // 삭제 성공 로그
        } catch (e) {
          print('Failed to delete bookmark: $e'); // 삭제 실패 로그
        }
      }
    } else {
      // 북마크 생성 로직
      print('Attempting to create bookmark'); // 생성 시도 로그
      try {
        await BookmarkService().createBookmark(widget.bookmarkType,
            policyId: widget.policyId, postId: widget.postId);
        print('Bookmark created successfully'); // 생성 성공 로그
      } catch (e) {
        print('Failed to create bookmark: $e'); // 생성 실패 로그
      }
    }

    setState(() {
      _isBookmarked = !_isBookmarked;
      if (!_isBookmarked) {
        _bookmarkId = null; // 북마크 삭제 후 _bookmarkId 초기화
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      color: _isBookmarked ? Colors.yellow : null, // 북마크 상태에 따라 아이콘 색상 변경
      onPressed: () async {
        print('체크중');

        final isLoggedIn = await _checkLoginStatus();
        if (!isLoggedIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인이 필요합니다.')),
          );
          return;
        }
        _toggleBookmark();
      },
    );
  }
}
