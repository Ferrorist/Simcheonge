import 'package:flutter/material.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  _MyPostScreenState createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  List<String> allItems = [];
  List<String> displayedItems = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 페이지 새로 로드될 때 검색 상태를 초기화
    displayedItems = allItems;
    _controller.clear();
    _controller.addListener(() {
      updateSearchQuery(_controller.text);
    });
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
                .where((item) =>
                    item.toLowerCase().contains(newQuery.toLowerCase()))
                .toList()
            : allItems;
      });
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
          return ListTile(
            title: Text(displayedItems[index]),
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
