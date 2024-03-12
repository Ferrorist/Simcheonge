import 'package:flutter/material.dart';
import 'package:simcheonge_front/wedgets/bottom_nav_item.dart';
import 'package:simcheonge_front/screens/chatbot_screen.dart';
import 'package:simcheonge_front/screens/article_screen.dart';
import 'package:simcheonge_front/screens/home_screen.dart';
import 'package:simcheonge_front/screens/news_screen.dart';
import 'package:simcheonge_front/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Your App Title',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
