import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/post_detail_screen.dart';
import 'package:simcheonge_front/services/post_service.dart';
import 'package:simcheonge_front/widgets/my_post_detail.dart';
import 'package:intl/intl.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  _MyPostScreenState createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  List<MyPost> allItems = []; // MyPost 객체의 리스트
  List<MyPost> displayedItems = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMyPosts();

    _controller.addListener(() {
      updateSearchQuery(_controller.text);
    });
  }

  Future<void> _loadMyPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      try {
        final posts = await PostService.getMyPosts('POS', 1);
        setState(() {
          allItems = posts;
          displayedItems = allItems;
        });
      } catch (e) {
        // 에러 처리
        print('Error fetching posts: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateSearchQuery(String newQuery) {
    if (mounted) {
      setState(() {
        displayedItems = newQuery.isNotEmpty
            ? allItems
                .where((post) => post.postName
                    .toLowerCase()
                    .contains(newQuery.toLowerCase()))
                .toList()
            : allItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
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
                    },
                  )
                : null,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: displayedItems.length,
        itemBuilder: (context, index) {
          final item = displayedItems[index];
          return ListTile(
            title: Text(item.postName),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(item.createdAt)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostDetailScreen(postId: item.postId)),
              );
            },
          );
        },
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: MyPostScreen()));
