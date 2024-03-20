import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simcheonge_front/screens/board_screen.dart';
import 'package:simcheonge_front/screens/chatbot_screen.dart';
import 'package:simcheonge_front/screens/news_screen.dart';
import 'package:simcheonge_front/screens/search_screen.dart';
import 'package:simcheonge_front/widgets/main_button.dart'; // 수정된 MainButton 위젯 import
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) changePage;

  const HomeScreen({super.key, required this.changePage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0; // 'activeIndex'를 상태 변수로 선언
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  Widget colorSlider(Color color, int index) => Container(
        width: double.infinity,
        height: 240,
        color: color,
      );

  Widget indicator() => Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        alignment: Alignment.bottomCenter,
        child: AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: colors.length,
          effect: JumpingDotEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: Colors.white,
              dotColor: Colors.white.withOpacity(0.6)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 48),
                  child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                          ),
                          itemCount: colors.length,
                          itemBuilder: (context, index, realIndex) {
                            return colorSlider(colors[index], index);
                          },
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: indicator()),
                      ])),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // 스크롤 동작 비활성화
                crossAxisCount: 2, // 2개의 열
                childAspectRatio: (1 / 0.85), // 아이템 비율 조정
                crossAxisSpacing: 15, // 가로 간격
                mainAxisSpacing: 15, // 세로 간격
                padding: const EdgeInsets.all(16), // GridView 패딩
                children: [
                  MainButton(
                    name: '챗봇',
                    icon: FontAwesomeIcons.robot,
                    isInverted: false,
                    onPressed: () {
                      widget.changePage(2);
                    },
                  ),
                  MainButton(
                    name: '검색',
                    icon: Icons.search,
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(1);
                    },
                  ),
                  MainButton(
                    name: '뉴스',
                    icon: FontAwesomeIcons.newspaper,
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(3);
                    },
                  ),
                  MainButton(
                    name: '게시판',
                    icon: FontAwesomeIcons.chalkboard,
                    isInverted: false,
                    onPressed: () {
                      widget.changePage(4);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
