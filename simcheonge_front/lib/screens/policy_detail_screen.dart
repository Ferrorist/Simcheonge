import 'package:flutter/material.dart';
import 'package:simcheonge_front/models/policy_detail.dart';
import 'package:simcheonge_front/services/policy_service.dart';
import 'package:simcheonge_front/widgets/bookmark_widget.dart';
import 'package:simcheonge_front/widgets/comment_widget.dart';
import 'package:word_break_text/word_break_text.dart';

// PolicyDetail 모델 import 필요, 경로는 실제 프로젝트 구조에 따라 달라짐
class PolicyDetailScreen extends StatelessWidget {
  final int policyId;

  const PolicyDetailScreen({super.key, required this.policyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '정책 상세보기',
          style: GoogleFonts.dongle(fontSize: 30), // Google Fonts의 Orbit 글꼴 적용
        ),
      ),
      body: FutureBuilder<PolicyDetail>(
        future: PolicyService.fetchPolicyDetail(policyId),
        builder: (context, snapshot) {
          // 로딩 중 상태
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 데이터 로드 완료
          if (snapshot.connectionState == ConnectionState.done) {
            // 에러가 발생한 경우
            if (snapshot.hasError) {
              return const Center(child: Text('정책 정보를 불러오는데 실패했습니다.'));
            }

            // 데이터가 있는 경우
            if (snapshot.hasData) {
              final policy = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(policy.policyName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {
                              print(policyId);
                              BookmarkWidget(
                                bookmarkType: 'POL', // 'POS' 타입으로 북마크 위젯 설정
                                policyId: policyId, // 현재 게시물 ID 전달
                              );
                              // 북마크 로직 구현
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(policy.policyIntro,
                          style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 20),
                      buildSection('지원 규모', policy.policySupportScale),
                      buildSection('지원 기간',
                          '${policy.policyStartDate} - ${policy.policyEndDate}'),
                      buildSection('지원 지역', policy.policyArea),
                      buildSection('주관 기관', policy.policyMainOrganization),
                      buildSection('운영 기관', policy.policyOperationOrganization),
                      buildSection('대상 연령', policy.policyAgeInfo),
                      buildSection('학력 요건', policy.policyEducationRequirements),
                      buildSection('전공 요건', policy.policyMajorRequirements),
                      buildSection('고용 상태', policy.policyEmploymentStatus),
                      buildSection('지원 내용', policy.policySupportContent),
                      buildSection('신청 절차', policy.policyApplicationProcedure),
                      buildSection('신청 제한', policy.policyEntryLimit),
                      buildSection('참고 사항', policy.policyEtc),
                      buildSection('참고 웹사이트', policy.policySiteAddress),
                      CommentWidget(
                        policyId: policyId,
                        commentType: 'POL',
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('정책 정보를 불러오는데 실패했습니다.'));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildSection(String title, String content) {
    if (content.isEmpty) {
      return Container();
    }

    // 괄호 안의 내용을 일시적으로 대체
    final bracketContents = <String>[];
    var modifiedContent =
        content.replaceAllMapped(RegExp(r'\([^\)]+\)'), (match) {
      bracketContents.add(match.group(0)!);
      return '⌜${bracketContents.length - 1}⌝'; // 괄호 임시 표시자
    });

    modifiedContent = modifiedContent.replaceAll(RegExp(r' {3}'), '\n');

    // 원 안의 숫자와 다른 일반적인 리스트 기호에 대한 추가 처리
    modifiedContent =
        modifiedContent.replaceAll(RegExp(r'(\d+)\. '), '\n\$1. ');
    modifiedContent = modifiedContent.replaceAll(RegExp(r'[-○*※❍] '), '\n- ');

    final splitPattern = RegExp(r'(?<=\n)|(?=[-○*※❍])');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 0),
        if (title == '지원 기간' && modifiedContent == '상시') // '지원 기간'이 '상시'인 경우
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '상시',
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ),
          )
        else // 그 외의 경우
          ...modifiedContent
              .split(splitPattern)
              .where((item) => item.isNotEmpty)
              .map((item) {
            String restoredItem = item.replaceAllMapped(RegExp(r'⌜(\d+)⌝'),
                (match) => bracketContents[int.parse(match.group(1)!)]);
            return Padding(
              padding: isRightAligned
                  ? const EdgeInsets.only(right: 20.0)
                  : EdgeInsets.zero,
              child: Align(
                alignment: isRightAligned
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  restoredItem,
                  style: defaultTextStyle,
                  textAlign: textAlign,
                ),
              ),
            );
          }),
        const SizedBox(height: 5),
        const Divider(),
      ],
    );
  }

  Widget buildWebsiteSection(String title, String url) {
    if (url.isEmpty) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        _launchURL(url.trim());
      },
      child: const Align(
        alignment: Alignment.centerRight,
        child: Text(
          '신청 홈페이지 바로가기',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
