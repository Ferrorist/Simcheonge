import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/login_screen.dart';
import 'package:simcheonge_front/screens/post_create_screen.dart';
import 'package:simcheonge_front/screens/post_detail_screen.dart';
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
  // 여기에 선택된 카테고리에 따라 게시글을 필터링하는 로직 추가
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<Map<String, dynamic>> _categoryOptions = [
    {'number': 2, 'name': '정책 추천'},
    {'number': 3, 'name': '공모전'},
    {'number': 4, 'name': '생활 꿀팁'},
    {'number': 5, 'name': '기타'},
  ];

  late Future<List<dynamic>> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = PostService.fetchPosts();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _postFuture = PostService.fetchPosts();
    });
  }

  String getCategoryName(int categoryNumber) {
    var category = _categoryOptions.firstWhere(
      (option) => option['number'] == categoryNumber,
      orElse: () => {'name': '기타'},
    );
    return category['name'];
  }

  void _navigateToDetailOrLogin(BuildContext context, int postId) async {
    String? token = await getSavedToken();
    if (token == null) {
      // 로그인하지 않았다면, 로그인 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // 로그인했다면, 게시글 상세 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailScreen(postId: postId),
        ),
      );
    }
  }

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
                // 검색 기능 구현
              },
            ),
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () async {
                String? token = await getSavedToken();
                print(token);
                if (token == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PostCreateScreen()),
                  );
                }
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPosts,
          child: FutureBuilder<List<dynamic>>(
            future: PostService.fetchPosts().then((posts) {
              _postFuture;
              // 서버에서 최신순으로 정렬되어 오지 않는 경우, 클라이언트 측에서 정렬
              posts.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
              return posts;
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      // null 검사 및 기본값 할당
                      var post = snapshot.data![index];
                      return InkWell(
                        onTap: () =>
                            _navigateToDetailOrLogin(context, post['postId']),
                        child: ListTile(
                          leading: Text(post['categoryName'] ?? '기타'),
                          title: Text(post['postName'] ?? '제목 없음'),
                          subtitle: Text(post['userNickname'] ?? '익명'),
                          trailing: Text(post['createdAt']?.substring(0, 10) ??
                              '날짜 정보 없음'),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('오류 발생: ${snapshot.error}');
                }
                return const Text('데이터가 없습니다.');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
