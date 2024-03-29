import 'package:flutter/material.dart';
import 'package:simcheonge_front/services/e_word_api.dart';
import 'package:simcheonge_front/models/e_word_model.dart';

class EconomicWordWidget extends StatefulWidget {
  const EconomicWordWidget({super.key});

  @override
  _EconomicWordWidgetState createState() => _EconomicWordWidgetState();
}

class _EconomicWordWidgetState extends State<EconomicWordWidget> {
  bool isExpanded = false;
  EWord? economicWord; // API로부터 받은 데이터를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadEconomicWord(); // 위젯 로드 시 경제 단어 데이터를 불러옵니다.
  }

  _loadEconomicWord() async {
    final api = EWordAPI();
    final wordData = await api.fetchEconomicWord();
    setState(() {
      economicWord = wordData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final contentStyle = theme.textTheme.bodyMedium;

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
                  color: Colors.blue[300],
                ),
                title: Text(economicWord?.data?.word ?? '로딩 중...',
                    style: titleStyle),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.blue[300],
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
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          economicWord?.data?.description ?? '상세 설명을 불러오는 중...',
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
