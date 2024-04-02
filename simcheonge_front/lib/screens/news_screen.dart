import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/widgets/economic_word.dart';
import 'package:simcheonge_front/screens/news_detail.dart';
import 'package:simcheonge_front/providers/economicWordProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simcheonge_front/widgets/pulldown.dart';
import 'package:provider/provider.dart';
import 'package:simcheonge_front/models/news_list_model.dart';
import 'package:simcheonge_front/services/news_list_api.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Data>? newsList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EconomicWordProvider>(context, listen: false)
          .fetchEconomicWord();
    });
    loadNewsList(); // 수정
  }

  Future<void> loadNewsList() async {
    final NewsList response = await fetchNewsList(); // 올바른 API 호출 함수 이름
    if (response.data != null) {
      setState(() {
        newsList = response.data;
      });
    }
  }

  void _onRefresh() async {
    await loadNewsList(); // 올바른 메서드 이름으로 수정
    await Provider.of<EconomicWordProvider>(context, listen: false)
        .fetchEconomicWord(); // 경제 용어 새로고침
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        const EconomicWordWidget(),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('실시간 주요 뉴스',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView.separated(
              itemCount: newsList?.length ?? 0,
              itemBuilder: (context, index) {
                final newsItem = newsList![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(
                          newsUrl: newsItem.link ?? '기본 URL',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 135, // 요소의 높이를 고정합니다.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsItem.publisher ?? '출처 없음',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 3, 10, 2),
                          child: Text(
                            newsItem.title ?? '제목 없음',
                            style: const TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                            maxLines: 2, // 최대 2줄까지만 표시
                            overflow:
                                TextOverflow.ellipsis, // 2줄 이상일 경우 '...'으로 표시
                          ),
                        ),
                        const Spacer(), // 제목과 원문보기 사이의 여백을 최대화합니다.
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '원문보기',
                              style: TextStyle(color: Colors.blueGrey[600]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                // 마지막 요소에는 구분선을 그리지 않습니다.
                return index == (newsList?.length ?? 1) - 1
                    ? Container()
                    : const Divider(height: 1);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ]),
    );
  }
}
