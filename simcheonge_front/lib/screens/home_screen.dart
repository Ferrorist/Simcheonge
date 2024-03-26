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

  Widget imageSlider(int index) => SizedBox(
        width: double.infinity,
        height: 240,
        child: Image.asset(
          'assets/home_screen/home_img${index + 1}.png', // 인덱스에 1을 더해 이미지 파일 이름을 맞춤
          fit: BoxFit.cover, // 이미지가 컨테이너를 꽉 채우도록 설정
        ),
      );

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 30),
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
                          itemCount: 5, // 총 5개의 이미지를 사용
                          itemBuilder: (context, index, realIndex) {
                            return imageSlider(index); // 새로운 이미지 슬라이더 함수를 사용
                          },
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: indicator()),
                      ])),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // 스크롤 동작 비활성화
                crossAxisCount: 1, // 2개의 열
                childAspectRatio: (1 / 0.3), // 아이템 비율 조정
                crossAxisSpacing: 15, // 가로 간격
                mainAxisSpacing: 20, // 세로 간격
                padding: const EdgeInsets.all(15), // GridView 패딩
                children: [
                  MainButton(
                    name: '챗봇',
                    descrip: '필요한 정책을 물어보세요!',
                    icon: Icons.question_answer_rounded,
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(2);
                    },
                  ),
                  MainButton(
                    name: '검색',
                    descrip: '검색을 통해 정책을 찾아요!',
                    icon: Icons.search,
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(1);
                    },
                  ),
                  MainButton(
                    name: '뉴스',
                    descrip: '오늘의 뉴스를 확인하세요!',
                    icon: FontAwesomeIcons.newspaper,
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(3);
                    },
                  ),
                  MainButton(
                    name: '게시판',
                    descrip: '유용한 정보를 공유해요!',
                    icon: FontAwesomeIcons.chalkboard,
                    isInverted: true,
                    onPressed: () {
                      widget.changePage(4);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Center(
                child: Text("ⓒ 2024. 9to6 all rights reserved."),
              ),
              const SizedBox(
                height: 3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
