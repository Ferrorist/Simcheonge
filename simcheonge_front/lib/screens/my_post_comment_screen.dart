import 'package:flutter/material.dart';
import 'package:simcheonge_front/widgets/side_app_bar.dart';

class MyPostCommentScreen extends StatefulWidget {
  const MyPostCommentScreen({super.key});

  @override
  _MyPostCommentScreenState createState() => _MyPostCommentScreenState();
}

class _MyPostCommentScreenState extends State<MyPostCommentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();

  List<String> allItems = [];
  List<String> displayedItems = [];

  @override
  void initState() {
    super.initState();
    displayedItems = allItems;
    _controller.addListener(() {
      updateSearchQuery(_controller.text);
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      displayedItems = allItems
          .where((item) => item.toLowerCase().contains(newQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                      onPressed: () => _controller.clear(),
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
                  allItems.remove(displayedItems[index]);
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
