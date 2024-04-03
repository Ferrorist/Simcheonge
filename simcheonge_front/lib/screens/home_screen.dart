import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simcheonge_front/screens/post_screen.dart';
import 'package:simcheonge_front/screens/chatbot_screen.dart';
import 'package:simcheonge_front/screens/news_screen.dart';
import 'package:simcheonge_front/screens/search_screen.dart';
import 'package:simcheonge_front/widgets/main_button.dart'; // 수정된 MainButton 위젯 import
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:simcheonge_front/screens/post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) changePage;

  const HomeScreen({super.key, required this.changePage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;

  Widget imageSlider(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // 이미지 슬라이더의 높이를 화면 높이의 일정 비율로 설정
    double sliderHeight = screenHeight * 0.4; // 예시로 40%로 설정

    // postId 매핑
    Map<int, int> postIds = {
      1: 56, // 2번째 이미지
      2: 54, // 3번째 이미지
      3: 55, // 4번째 이미지
      4: 57, // 5번째 이미지
    };

    return GestureDetector(
      onTap: () {
        if (postIds.containsKey(index)) {
          int postId = postIds[index]!;
          // Navigator를 사용하여 PostDetailScreen으로 이동
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailScreen(postId: postId)));
        }
      },
      child: SizedBox(
        width: screenWidth,
        height: sliderHeight,
        child: Image.asset(
          'assets/home_screen/home_img${index + 1}.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget indicator() => Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        alignment: Alignment.bottomCenter,
        child: AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: 5,
          effect: JumpingDotEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: const Color.fromARGB(255, 7, 7, 7),
              dotColor: Colors.white.withOpacity(0.6)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // 화면의 높이와 너비를 계산
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          // ListView를 Column으로 변경
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 30),
                child:
                    Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      },
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      autoPlay: true, // 자동 재생 활성화
                      autoPlayInterval:
                          const Duration(seconds: 5), // 3초마다 슬라이드 전환
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index, realIndex) {
                      return imageSlider(index);
                    },
                  ),
                  Align(alignment: Alignment.bottomCenter, child: indicator()),
                ])),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // 스크롤 동작 비활성화
                crossAxisCount: 2, // 2개의 열
                childAspectRatio: 1 / 0.9, // 비율 조정
                crossAxisSpacing: 18, // 가로 간격
                mainAxisSpacing: 18, // 세로 간격
                padding: const EdgeInsets.all(15), // GridView 패딩
                children: [
                  MainButton(
                    name: 'AI 채팅',
                    imagePath:
                        'assets/home_screen/chat_icon.png', // icon 대신 imagePath 사용
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(2);
                    },
                  ),
                  MainButton(
                    name: '정책 검색',
                    imagePath:
                        'assets/home_screen/search_icon.png', // 이미지 경로 변경
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(1);
                    },
                  ),
                  MainButton(
                    name: '뉴스 & 상식',
                    imagePath: 'assets/home_screen/news_icon.png', // 이미지 경로 변경
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(3);
                    },
                  ),
                  MainButton(
                    name: '게시판',
                    imagePath: 'assets/home_screen/board_icon.png', // 이미지 경로 변경
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(4);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text("ⓒ 2024. 9to6 all rights reserved."),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
