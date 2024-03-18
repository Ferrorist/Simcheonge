import 'package:flutter/material.dart';
import 'package:simcheonge_front/customIcons/custom_icons.dart';
import 'package:simcheonge_front/screens/bookmark_screen.dart';
import 'package:simcheonge_front/widgets/bottom_nav_item.dart';
import 'package:simcheonge_front/screens/chatbot_screen.dart';
import 'package:simcheonge_front/screens/board_screen.dart';
import 'package:simcheonge_front/screens/home_screen.dart';
import 'package:simcheonge_front/screens/news_screen.dart';
import 'package:simcheonge_front/screens/search_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simcheonge_front/widgets/side_app_bar.dart';

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
  DateTime? lastPressed;

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
      default:
        return '앱';
    }
  }

  void changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
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
          centerTitle: true, // 중앙 정렬
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () =>
                  _scaffoldKey.currentState?.openEndDrawer(), // 오른쪽 드로어를 엽니다.
            ),
          ],
        ),
        endDrawer: const SideAppBar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(changePage: changePage),
            const SearchScreen(),
            const ChatbotScreen(),
            const NewsScreen(),
            const BoardScreen(),
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
      ),
    );
  }
}
