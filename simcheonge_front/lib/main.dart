import 'package:flutter/material.dart';
import 'package:simcheonge_front/customIcons/custom_icons.dart';
import 'package:simcheonge_front/widgets/bottom_nav_item.dart';
import 'package:simcheonge_front/screens/chatbot_screen.dart';
import 'package:simcheonge_front/screens/article_screen.dart';
import 'package:simcheonge_front/screens/home_screen.dart';
import 'package:simcheonge_front/screens/news_screen.dart';
import 'package:simcheonge_front/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // 페이지마다 다른 제목을 반환하는 함수
  String getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return '심청이';
      case 1:
        return '검색';
      case 2:
        return '심청이 챗봇';
      case 3:
        return '뉴스';
      case 4:
        return '게시판';
      default:
        return '앱';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(getAppBarTitle()),
        centerTitle: true, // 중앙 정렬
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            iconSize: 35, // 원하는 아이콘으로 변경
            onPressed: () =>
                _scaffoldKey.currentState?.openEndDrawer(), // 오른쪽 드로어를 엽니다.
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Theme(
          data: Theme.of(context).copyWith(
              dividerColor:
                  Colors.transparent), // ExpansionTile의 divider 색상을 투명하게 설정
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                        child: UserAccountsDrawerHeader(
                          accountName: const Text(
                            '김싸피님',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w600),
                          ),
                          accountEmail: const Text(
                            '환영합니다',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w300),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[200],
                          ),
                        ),
                      ),
                      ExpansionTile(
                        leading: Icon(
                          Icons.draw,
                          color: Colors.grey[850],
                        ),
                        title: const Text(
                          '내가 쓴 글',
                          style: TextStyle(fontSize: 20),
                        ),
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print('게시글 클릭됨');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Row(
                                children: <Widget>[
                                  SizedBox(width: 70.0),
                                  Text('게시글', style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print('게시글 댓글 클릭됨');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Row(
                                children: <Widget>[
                                  SizedBox(width: 70.0),
                                  Text('게시글 댓글',
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print('정책 댓글 클릭됨');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Row(
                                children: <Widget>[
                                  SizedBox(width: 70.0),
                                  Text('정책 댓글', style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        leading: Icon(
                          Icons.bookmarks,
                          color: Colors.grey[850],
                        ),
                        title:
                            const Text('책갈피', style: TextStyle(fontSize: 20)),
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print('책갈피 항목 1 클릭됨');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Row(
                                children: <Widget>[
                                  SizedBox(width: 70.0),
                                  Text('정책', style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print('책갈피 항목 2 클릭됨');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Row(
                                children: <Widget>[
                                  SizedBox(width: 70.0),
                                  Text('게시글', style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.grey[850],
                        ),
                        title: const Text('내 정보 관리',
                            style: TextStyle(fontSize: 20)),
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print('정보 관리 항목 1 클릭됨');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Row(
                                children: <Widget>[
                                  SizedBox(width: 70.0),
                                  Text('닉네임 변경',
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print('정보 관리 항목 2 클릭됨');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Row(
                                children: <Widget>[
                                  SizedBox(width: 70.0),
                                  Text('비밀번호 수정',
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // 다른 ExpansionTile 추가 가능
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.red[200],
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.grey[850]),
                  title: const Text('로그아웃'),
                  onTap: () {
                    // 로그아웃 기능 구현
                    print('로그아웃');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeScreen(),
          SearchScreen(),
          ChatbotScreen(),
          NewsScreen(),
          ArticleScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        enableFeedback: false,
        iconSize: 32.0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: bottomNavItems
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(e.iconData),
                activeIcon: Icon(e.activeIconData),
                label: e.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
