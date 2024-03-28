import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/login_screen.dart';
import 'package:simcheonge_front/screens/post_create_screen.dart';
import 'package:simcheonge_front/services/post_service.dart';

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

Future<String?> getSavedToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

void _showFilterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('카테고리 선택'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ListTile(
                title: const Text('전체'),
                onTap: () => _filterPosts(context, 1),
              ),
              ListTile(
                title: const Text('정책 추천'),
                onTap: () => _filterPosts(context, 2),
              ),
              ListTile(
                title: const Text('공모전'),
                onTap: () => _filterPosts(context, 3),
              ),
              ListTile(
                title: const Text('생활 꿀팁'),
                onTap: () => _filterPosts(context, 4),
              ),
              ListTile(
                title: const Text('기타'),
                onTap: () => _filterPosts(context, 5),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _filterPosts(BuildContext context, int categoryNumber) {
  Navigator.of(context).pop(); // 다이얼로그 닫기
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<String> bookmarkedItems =
      List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
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
              onPressed: () async {
                String? token = await getSavedToken();
                print(token);
                if (token == null) {
                  // 토큰이 없다면 로그인 화면으로 이동합니다.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen(), // 로그인 화면으로 변경해주세요
                    ),
                  );
                } else {
                  // 토큰이 있다면 PostCreateScreen으로 이동합니다.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostCreateScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: PostService.fetchPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data![index];
                    return ListTile(
                      leading: Text(post['categoryCode']), // 카테고리
                      title: Text(post['postName']), // 게시글 제목
                      subtitle: Text(post['userNickname']), // 작성자 닉네임
                      trailing: Text(post['createdAt']), // 생성 날짜
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // 에러가 있는 경우 에러 메시지를 표시하는 위젯을 반환
                return Text('${snapshot.error}');
              } else {
                // 데이터가 없는 경우
                return const Text('데이터가 없습니다.');
              }
            }
            // 데이터를 불러오는 동안 로딩 인디케이터를 표시
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
