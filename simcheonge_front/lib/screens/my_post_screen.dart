import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';
import 'package:simcheonge_front/widgets/bookmark_detail.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  _MyPostScreenState createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  List<Bookmark> allItems = []; // Bookmark 객체의 리스트
  List<Bookmark> displayedItems = [];
  final TextEditingController _controller = TextEditingController();
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();

    _checkLoginStatus().then((isLoggedIn) {
      if (isLoggedIn) {
        _bookmarkService.getBookmarks('POS').then((bookmarks) {
          setState(() {
            allItems = bookmarks;
            displayedItems = allItems;
          });
        });
      }
    });

    _controller.addListener(() {
      updateSearchQuery(_controller.text);
    });
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    return accessToken != null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateSearchQuery(String newQuery) {
    if (mounted) {
      setState(
        () {
          displayedItems = newQuery.isNotEmpty
              ? allItems
                  .where((bookmark) => bookmark.bookmarkType
                      .toLowerCase()
                      .contains(newQuery.toLowerCase()))
                  .toList()
              : allItems;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: () {
                        _controller.clear();
                        // 여기서 updateSearchQuery를 명시적으로 호출할 필요가 없습니다.
                        // 왜냐하면 _controller.clear()가 리스너를 통해 이미 updateSearchQuery를 호출하기 때문입니다.
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: displayedItems.length,
        itemBuilder: (context, index) {
          final item = displayedItems[index];
          return ListTile(
            title: Text(item.bookmarkType),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                setState(() {
                  allItems.removeWhere((item) => item == displayedItems[index]);
                  displayedItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: MyPostScreen()));
