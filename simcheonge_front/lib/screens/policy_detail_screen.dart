import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simcheonge_front/services/policy_service.dart';
import 'package:simcheonge_front/widgets/policy_detail.dart';
import 'package:word_break_text/word_break_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      Text(policy.policyName,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(policy.policyIntro,
                          style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 20),
                      buildSection('지원 규모', policy.policySupportScale),
                      buildSection(
                          '지원 기간',
                          policy.policyPeriodTypeCode == '상시'
                              ? '상시'
                              : '${_formatDate(policy.policyStartDate)} ~ ${_formatDate(policy.policyEndDate)}'),
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
                      buildWebsiteSection('참고 웹사이트', policy.policySiteAddress),
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

  String _formatDate(String date) {
    if (date.isEmpty) {
      return '';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Widget buildSection(String title, String content) {
    if (content.isEmpty) {
      return Container();
    }

    final bracketContents = <String>[];
    var modifiedContent =
        content.replaceAllMapped(RegExp(r'\([^\)]+\)'), (match) {
      bracketContents.add(match.group(0)!);
      return '⌜${bracketContents.length - 1}⌝';
    });

    if (title == '지원 내용' || title == '신청 제한' || title == '참고 사항') {
      modifiedContent =
          modifiedContent.replaceAll(RegExp(r'(\d+)\. '), '\n\$1. ');
      modifiedContent =
          modifiedContent.replaceAll(RegExp(r'[-○●■□◆★☆※❖•] '), '\n- ');
      modifiedContent =
          modifiedContent.replaceAll(RegExp(r'[\u2460-\u2473]'), '\n\$0');
    }
    final splitPattern = RegExp(r'(?<=\n)');
    TextStyle defaultTextStyle =
        TextStyle(color: Colors.grey.shade800, fontSize: 16);
    TextAlign textAlign = TextAlign.start;

    bool isRightAligned = [
      '지원 규모',
      '지원 기간',
      '지원 지역',
      '주관 기관',
      '운영 기관',
      '대상 연령',
      '학력 요건',
      '전공 요건',
      '고용 상태',
      '참고 웹사이트'
    ].contains(title);

    EdgeInsets padding = isRightAligned
        ? const EdgeInsets.only(bottom: 16.0, right: 20.0)
        : const EdgeInsets.only(bottom: 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 4),
          child: Text(title,
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

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('주소를 열 수 없습니다: $url');
      }
    } catch (e) {
      print('주소를 열 수 없습니다: $url');
    }
  }
}
