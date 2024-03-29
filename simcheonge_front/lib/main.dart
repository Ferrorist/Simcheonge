import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/auth/authentication_manager.dart';
import 'package:simcheonge_front/screens/bookmark_policy_screen.dart';
import 'package:simcheonge_front/screens/bookmark_post_screen.dart';
import 'package:simcheonge_front/screens/login_screen.dart';
import 'package:simcheonge_front/screens/my_policy_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_screen.dart';
import 'package:simcheonge_front/widgets/bottom_nav_item.dart';
import 'package:simcheonge_front/screens/chatbot_screen.dart';
import 'package:simcheonge_front/screens/post_screen.dart';
import 'package:simcheonge_front/screens/home_screen.dart';
import 'package:simcheonge_front/screens/news_screen.dart';
import 'package:simcheonge_front/screens/search_screen.dart';
import 'package:simcheonge_front/widgets/side_app_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

Future<bool> checkLoginStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');
  return accessToken != null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: AuthenticationManager.checkAndRefreshTokenIfNeeded(),
        builder: (context, snapshot) {
          // 토큰 유효성 검사가 완료되기 전 로딩 화면 표시
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // 토큰이 유효하면 메인 화면(MyHomePage)으로, 그렇지 않으면 로그인 화면(LoginScreen)으로 이동

          return const MyHomePage();
        },
      ),
      locale: const Locale('ko', 'KR'), // 앱의 로케일을 한국어로 설정
      supportedLocales: const [
        Locale('ko', 'KR'), // 지원하는 로케일 목록에 한국어 추가
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // 선택된 페이지 인덱스
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? lastPressed;
  bool isLoggedIn = false; // 로그인 상태 변수 추가

  // 로그인 상태 업데이트 함수
  void updateLoginStatus(bool status) {
    setState(() {
      isLoggedIn = status;
    });
  }

  // 페이지마다 다른 제목을 반환하는 함수
  String getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return '심청이';
      case 1:
        return '정책 검색';
      case 2:
        return '심청이 챗봇';
      case 3:
        return '뉴스';
      case 4:
        return '정보게시판';
      case 5:
        return '내가 쓴 게시글';
      case 6:
        return '내가 쓴 댓글(게시글)';
      case 7:
        return '내가 쓴 댓글(정책)';
      case 8:
        return '정책 북마크';
      case 9:
        return '게시글 북마크';
      default:
        return '앱';
    }
  }

  // 페이지 변경 함수 수정
  void changePage(int index, {bool isSideBar = false}) {
    setState(() {
      // 사이드바에서 호출되면 _selectedIndex를 업데이트하고, 바텀 네비게이션 항목이 아니면 -1로 설정
      _selectedIndex =
          isSideBar && (index < 0 || index > bottomNavItems.length - 1)
              ? -1
              : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_scaffoldKey.currentState!.isEndDrawerOpen) {
          // endDrawer가 열려 있다면 닫습니다.
          Navigator.of(context).pop();
          return false; // 이벤트를 더 이상 전파하지 않음
        } else if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // 홈 화면으로 돌아갑니다.
        } else if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('한 번 더 누르면 앱이 종료됩니다'),
              duration: Duration(seconds: 2),
            ),
          );
          return false; // 시스템 레벨의 뒤로가기 동작 방지
        }
        return true; // 시스템 레벨의 뒤로가기 동작을 허용 (앱 종료)
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(getAppBarTitle()),
          centerTitle: true,
          elevation: 0.0,
          actions: <Widget>[
            FutureBuilder<bool>(
              future: checkLoginStatus(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // 로딩 중 표시. 필요에 따라 로딩 위젯으로 대체 가능
                }
                final isLoggedIn =
                    snapshot.data ?? false; // isLoggedIn 상태를 snapshot에서 추출
                return Row(
                  children: [
                    if (!isLoggedIn)
                      IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                      updateLoginStatus: updateLoginStatus)));
                        },
                      ),
                    if (isLoggedIn)
                      IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openEndDrawer(),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        endDrawer: SideAppBar(changePage: changePage),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(changePage: changePage),
            const SearchScreen(),
            const ChatbotScreen(),
            const NewsScreen(),
            const PostScreen(),
            const MyPostScreen(),
            const MyPostCommentScreen(),
            const MyPolicyCommentScreen(),
            const BookmarkPolicyScreen(),
            const BookmarkPostScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          // 바텀 네비게이션 바의 선택된 인덱스를 설정
          // 선택된 인덱스가 지정 범위를 벗어날 경우, 모든 항목이 선택되지 않은 것처럼 처리
          currentIndex:
              _selectedIndex >= 0 && _selectedIndex < bottomNavItems.length
                  ? _selectedIndex
                  : 0,
          selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
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
              .map((e) => BottomNavigationBarItem(
                    icon: Icon(e.iconData),
                    activeIcon: Icon(e.activeIconData),
                    label: e.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
