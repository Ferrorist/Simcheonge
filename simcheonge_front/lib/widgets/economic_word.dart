import 'package:flutter/material.dart';

class EconomicWordWidget extends StatefulWidget {
  const EconomicWordWidget({super.key});

  @override
  _EconomicWordWidgetState createState() => _EconomicWordWidgetState();
}

class _EconomicWordWidgetState extends State<EconomicWordWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final contentStyle = theme.textTheme.bodyMedium;

    // 최대 높이를 설정
    final maxHeight = MediaQuery.of(context).size.height * 0.35;

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Material(
          color: isExpanded ? Colors.green.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  isExpanded
                      ? Icons.tips_and_updates
                      : Icons.tips_and_updates_outlined,
                  color: isExpanded ? Colors.blue[300] : Colors.blue[300],
                ),
                title: Text('가상통화', style: titleStyle),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: isExpanded ? Colors.white : Colors.blue[300],
                ),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              if (isExpanded) const Divider(color: Colors.black, thickness: 1),
              AnimatedCrossFade(
                firstChild: const SizedBox(),
                secondChild: Padding(
                  // 이 Padding은 ConstrainedBox 전체를 감싸 아코디언 내부에 마진을 줍니다.
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0,
                      20.0), // 이 값을 조절하여 내부 마진의 크기를 변경할 수 있습니다.
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          '''암호화폐 문서에서 더 상세한 설명을 읽을 수 있다.

유럽중앙은행(ECB), 미국 재무부, 유럽은행감독청에서 내린 정의에 따르면, 가상 화폐란 정부에 의해 통제 받지 않는 디지털 화폐의 일종으로 개발자가 발행 및 관리하며 특정한 가상 커뮤니티에서만 통용되는 결제 수단을 말한다.[4] 대부분의 암호화폐는 가상 화폐의 조건 중 일부분을 충족한다. 하지만 상당수 온라인과 오프라인 매장에서 결제 수단으로 받는 비트코인은 디지털 화폐이기는 하나, 가상 화폐는 아니게 된다. 또한 대부분의 암호화폐는 개발자가 발행하지는 않기 때문에 발행 측면에서 보자면 대다수의 암호화폐는 가상화폐가 아니게 된다.

미국 재무부 금융범죄단속반(FinCEN)은 "일부 환경에서는 (법화(法貨)인) 화폐처럼 작동하지만 진짜 화폐의 모든 특성을 갖추고 있지는 못한 교환 수단"이란 뜻으로 '가상화폐'라는 말을 쓰고 있으며, 전자상품권 등을 제외하고 비트코인·이더리움·리플 등 암호화폐를 가리킬 때는 가상화폐라는 단어를 쓰지 않는다. 암호화폐·가상화폐·가상통화·가상증표…뭐라 불러야? 2018-01-14

가상 화폐라는 개념에는 다양한 종류의 화폐란 개념을 구현만 한 것들을 포함한다. 게임상 사이버머니나 사이버뱅크 거래 역시 가상 화폐로 취급된다. 그중 실제로 화폐화될 수 있는 개념을 전자화폐로 통칭하며 여기엔 페이팔과 같은 결제 시스템 역시 포함되는 말이다. 그리고 그중 암호화되어 화폐의 생산주체라는 개념 자체가 없어진 것을 암호화폐라고 부른다. 다만 암호화폐라는 개념이 대중들에게 생소하기 때문에 그냥 암호화폐를 가상화폐라고 부르는 경우가 꽤 많은 실정이다. 예를 들어 대한민국의 암호화폐 거래소들도 스스로를 '가상화폐 거래소'라고 표현하는 경우가 종종 있다.

한편, 암호화폐 투자자들 사이에서는 비공식적으로 그냥 코인으로 부르는 경우가 많다. 또한 암호화폐를 가상 화폐라고 부르면 게임 머니 등 가상 세계에서 쓸 수 있는 돈이나, 가상 공간에서의 전자결제에 사용할 수 있는 카카오 페이나 네이버 페이 등의 온라인 지불 수단과 헷갈릴 우려가 있다고 하나 최근 주목을 받기 시작한 후로 대다수의 언론에서 암호화폐에 대하여 지속적으로 가상화폐라는 표현을 썼기 때문에 2018년 1월 현재는 가상화폐가 다른 의미로 오해될 우려는 많이 줄어든 상태다.

발행 주체에 종속되지 않는 사이버 화폐를 만들려는 노력 끝에 암호화폐(cryptocurrency)라는 개념이 등장했다.

미국정부는 암호화폐를, 거래 보안과 추가 유닛 제어, 자산 전송의 검증을 위해 암호화 디자인된, 디지털 자산(digital asset)으로 규정하고 있다.

유사한 용어로 디지털 화폐나 전자 화폐가 있다. 디지털로 화폐의 주고받음을 표현하는 화폐를 말한다.

박상기 법무부 장관은 공식 석상에서 자의적으로 암호화폐를 가상증표라고 명명하였다. 대한민국 정부에서 가짜라는 뉘앙스의 가상이라는 단어를 붙이고 화폐라는 용어를 안 쓰기 위해 통화라는 단어를 썼는데 장관은 통화도 아니라는 뜻의 증표라는 단어를 쓴 것. (참고로, 국제자금세탁방지기구(FATF)도 "암호화폐(가상통화)는 화폐가 아니다"고 선언했다. 그리고 가상통화와 암호자산으로 혼용해 사용해왔던 용어를 가상자산(Virtual asset)으로 통일했다.##) 장관은 전 부처가 이와 함께 가상 증표 거래소를 폐쇄하는 것으로 합의한 상황이라고 이야기 했으나 몇 시간도 채 지나지 않아 청와대가 정부 내에서 협의중인 사항이라고 발표했다.

2020년 코로나 쇼크로 전세계적으로 인터넷 상거래가 폭증하게 되면서 핀테크의 발전과 함께 이제는 더이상 국가 중앙은행이 국가의 통화발행권과 유통권을 쥐고 흔들기 쉽지 않게 되었다. 이로 인해 등장한 암호화폐의 성장과, 페이스북이 리브라를 통해 선언한 독자적인 사이버 화폐의 등장으로 인해 중국의 DCEP를 시작으로 한 중앙은행의 디지털 화폐 발권 및 전환 시도가[5] 점점 속도를 내고 있다. 중앙은행 디지털화폐 참조. 이렇게 될 경우 어쩌면 생각보다 빨리 종이와 금속으로 된 지폐와 동전이 말그대로 종이조각,금속조각이 되고 데이타로 기록된 화폐만이 정부에서 유통하는 유일한 화폐다라는 시장의 전환이 빨리 이루어질 상황에 놓였다.

그러나 아직 갈길이 먼데 우선 현금을 왕창 쌓아놓고 있던 부자들이 가만있지 않을 거라 저항이 매우 클 것이다. 지금 비트코인이 다 죽어가다 다시 떡상한 이유중 하나가 바로 이렇게 중국발 중앙은행 CBDC 전환으로 잘못하면 가진 지폐가 전부 종이쪼가리가 되고, 자기 재산 운용정보를 정부가 다 감시하게 되는 상황이 되기 전에 빨리 돈을 해외로 빼돌리려고 하는 과정에서 국제 태환이 전혀 필요없이 그냥 거래가 되는 비트코인의 익명성때문에 부자들이 비트코인을 사들여서 다시 떡상하게 된 것. 게다가 2022년 LUNA 대폭락이 일어나면서 암호화폐가 아직 해결되지 않은 오프라인 횡령과 엮여 온라인 횡령으로 확장되어 악용될 경우 국가적 손실이 일어날 것이라는 예측이 도는 등 불안정성은 현재진행형이다''', // 여기서는 예시로 텍스트를 요약했습니다.
                          style: contentStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
