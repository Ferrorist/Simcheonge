import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simcheonge_front/screens/board_screen.dart';
import 'package:simcheonge_front/screens/chatbot_screen.dart';
import 'package:simcheonge_front/screens/news_screen.dart';
import 'package:simcheonge_front/screens/search_screen.dart';
import 'package:simcheonge_front/widgets/main_button.dart'; // MainButton 위젯 import
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) changePage;

  const HomeScreen({super.key, required this.changePage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 'activeIndex'를 상태 변수로 선언
  int activeIndex = 0;
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16), // 여기서 왼쪽 마진 추가
                    child: Text(
                      'SERVICES',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    child: MainButton(
                      name: '챗봇',
                      sub: 'AI를 통해 자신에게 맞는 정책을 찾아요!',
                      icon: FontAwesomeIcons.robot,
                      isInverted: false,
                      onPressed: () {
                        widget.changePage(
                            2); // 'widget.'을 추가하여 부모 위젯의 changePage 함수에 접근
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    child: MainButton(
                      name: '검색',
                      sub: '조건에 맞는 정책을 검색해요.',
                      icon: Icons.search,
                      isInverted: true,
                      onPressed: () {
                        widget.changePage(1); // 동일하게 'widget.'을 추가
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    child: MainButton(
                      name: '뉴스',
                      sub: '최신 기사를 확인하세요!',
                      icon: FontAwesomeIcons.newspaper,
                      isInverted: false,
                      onPressed: () {
                        widget.changePage(3); // 동일하게 'widget.'을 추가
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                    child: MainButton(
                      name: '게시판',
                      sub: '다른 사람들과 소통해요!',
                      icon: FontAwesomeIcons.chalkboard,
                      isInverted: true,
                      onPressed: () {
                        widget.changePage(4); // 동일하게 'widget.'을 추가
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
