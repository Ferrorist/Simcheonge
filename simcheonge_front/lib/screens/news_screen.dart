import 'package:flutter/material.dart';
import 'package:simcheonge_front/widgets/economic_word.dart';
import 'package:simcheonge_front/screens/news_detail.dart';
import 'package:simcheonge_front/providers/economicWordProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simcheonge_front/widgets/pulldown.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    // 최초 데이터 로딩
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EconomicWordProvider>(context, listen: false)
          .fetchEconomicWord();
    });
  }

  void _onRefresh(BuildContext context) async {
    // 경제 단어 데이터를 새로고침합니다.
    await Provider.of<EconomicWordProvider>(context, listen: false)
        .fetchEconomicWord();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newsData = [
      {
        'title': "군복무 기간만큼 국민연금 더 준다…이러쿵저러쿵 어쩌고 저쩌고",
        'content':
            '연평해전·천안함 피격사건 참전자 모두 보훈 연평해전·천안함 피격사건 참전자 모두 보훈 연평해전·천안함 피격사건 참전자 모두 보훈 연평해전·천안함 피격사건 참전자 모두 보훈 연평해전·천안함 피격사건 참전자 모두 보훈 연평해전·천안함 피격사건 참전자 모두 보훈'
      },
      {'title': '제목 1', 'content': '내용 1'},
      {
        'title': '제목 1',
        'content':
            '내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1내용 1'
      },
      {'title': '제목 1', 'content': '내용 1'},
      {'title': '제목 1', 'content': '내용 1'},
      {'title': '제목 1', 'content': '내용 1'},
      {'title': '제목 1', 'content': '내용 1'},
      {'title': '제목 1', 'content': '내용 1'},
      {'title': '제목 1', 'content': '내용 1'},
    ];

    return Scaffold(
      body: Column(children: <Widget>[
        const EconomicWordWidget(),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('오늘의 주요 뉴스',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: () => _onRefresh(context),
            child: ListView.separated(
              itemCount: newsData.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 1.0),
                  child: Container(
                    height: 150, // 뉴스 항목의 높이 고정
                    padding: const EdgeInsets.only(
                        bottom: 0.0), // 원문보기 버튼의 아래쪽 여백 조정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsData[index]['title']!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 15.0,
                            ), // 내용의 여백을 조정
                            child: Text(
                              newsData[index]['content']!,
                              style: const TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      NewsDetailScreen(newsId: 'news_$index'),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text('원문보기'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
