import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsId;
  final String articleTitle = '기사 제목';
  final String articleDate = '2024-03-19';
  final String articleContent = '''
당정 간 갈등은 비례대표 공천으로도 번지는 양상이다.

핵심 친윤계로 꼽히는 이철규 의원은 비례위성정당 국민의미래 비례대표 후보 명단을 두고 호남·당직자가 배제됐다고 지적하며 "바로잡기 바란다"고 지도부에 공개 촉구했다.

실명을 거론하진 않았지만, 두 번째 비례대표 공천을 받은 김예지 의원과 이시우 전 국무총리실 서기관, 강세원 전 대통령실 행정관 등이 당선권에 포함된 것을 겨냥한 것으로 당 안팎에선 받아들여졌다. 윤 대통령과 가까운 것으로 알려진 호남 출신의 주기환 광주시당 위원장이 당선권 밖에 배치된 데 대한 불만도 드러난 것으로 해석됐다.

이 의원의 공개 비판에는 한 위원장에 대한 대통령실의 불만 기류가 투영된 것 아니겠냐는 해석이 나온다.

이날도 친윤 핵심 중진인 권성동 의원이 비례대표 명단과 관련해 "국민과 한 약속은 지키는 게 맞다"며 호남 인사 등의 배치 순서에 문제를 제기했다.

한 친윤계 의원은 통화에서 "한 위원장이 선거 과정에서 고생한 핵심 당직자들을 넣지도 않고 주먹구구식으로 공천했다"고 비판했다.

그러나 한 위원장의 측근으로 분류되는 장 사무총장은 이날 이 의원의 문제 제기에 대해 "절차상 특별한 문제가 없다는 보고를 받았다"고 말했다. 비례대표 후보가 '친한' 인사로 채워졌다'는 지적에 대해서도 "납득하기 어렵다"고 반박했다.

양측의 갈등이 지난 1월 이후 잠복해 있다가 이번 사안을 계기로 다시 수면 위로 떠오른 것이라는 이야기도 나온다.

당정은 당시 김 여사 명품백 의혹 대응에 대해 온도 차를 보이다가 윤 대통령의 사퇴 요구를 한 위원장이 거부하면서 정면충돌 양상을 보였다. 한 위원장의 김경율 비대위원 마포을 출마 지지를 놓고 '사천' 논란이 불거진 것도 갈등 요인이 됐다.

이후 충남 서천시장 화재 현장에서 두 사람이 만나며 갈등이 봉합되는 모습을 보였지만, 해소되지 않은 감정의 앙금이 이번 일을 계기로 다시 표출되는 게 아니냐는 해석이 나온다.

여권에서는 당정 갈등이 총선 악재가 될 수 있다는 우려와 함께 조속한 해결을 요구하는 목소리가 나오고 있다. 특히 당에선 대통령실의 입장 변화에 기대를 거는 분위기도 감지된다.

한 수도권 출마자는 "당정이 선거 국면에서 갈등하면 절대 안 된다"며 "양쪽이 열어놓고 소통해야 한다"고 말했다.

하지만 여당 지도부가 공개적으로 대통령실에 의견을 전달한 상황에서 아무런 변화가 없고, 수도권을 포함한 격전지 상황이 계속 악화할 경우 당내에서 여러 요구가 분출할 수도 있다는 관측도 없지 않다..''';
  final String articleAuthor = '기자 : 홍길동';
  final String articlePublisher = '데일리 뉴스';

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('뉴스 전문 읽기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 16.0, 16.0, 8.0),
            child: Text(
              articleTitle,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Align(
              alignment: Alignment.centerRight, // 날짜를 우측 정렬합니다.
              child: Text(
                articleDate,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0), // 내용 여백, 원하는 대로 조절 가능
                    child: Text(
                      articleContent,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        articleAuthor,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        articlePublisher,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // 원문 링크 이동 로직
                        },
                        child:
                            const Text('원문 보기', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
