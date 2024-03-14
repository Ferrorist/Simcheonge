import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final List<String> items;

  DataSearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? items
        : items
            .where((p) => p.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<String> bookmarkedItems =
      List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // 필터 아이콘을 클릭했을 때의 동작을 여기에 작성하세요.
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(bookmarkedItems),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () {
                // 게시글 작성 아이콘을 클릭했을 때의 동작을 여기에 작성하세요.
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: bookmarkedItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bookmarkedItems[index]),
              trailing: IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  setState(() {
                    bookmarkedItems.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
