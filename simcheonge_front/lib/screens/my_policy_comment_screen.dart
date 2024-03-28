import 'package:flutter/material.dart';
import 'package:simcheonge_front/widgets/side_app_bar.dart';

class MyPolicyCommentScreen extends StatefulWidget {
  const MyPolicyCommentScreen({super.key});

  @override
  _MyPolicyCommentScreenState createState() => _MyPolicyCommentScreenState();
}

class _MyPolicyCommentScreenState extends State<MyPolicyCommentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();

  // 더미 데이터를 생성합니다.
  final List<String> allItems =
      List<String>.generate(20, (i) => 'Comment ${i + 1}');
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    // 초기 상태에서는 모든 아이템을 보여줍니다.
    filteredItems = List.from(allItems);
    // 텍스트 필드의 변화를 감지하여 검색 결과를 필터링합니다.
    _controller.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _controller.text.toLowerCase();
    final matchedItems = allItems.where((item) {
      return item.toLowerCase().contains(query);
    }).toList();

    setState(() {
      filteredItems = matchedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '정책 댓글 검색...',
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
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredItems[index]),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                // 기능 구현 예시 (아이템 북마크 기능 등)
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
