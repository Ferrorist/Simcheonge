import 'package:flutter/material.dart';
import 'package:simcheonge_front/services/policy_service.dart';
import 'package:simcheonge_front/widgets/policy_detail.dart'; // 가정한 경로, 실제 경로로 변경 필요

// PolicyDetail 모델 import 필요, 경로는 실제 프로젝트 구조에 따라 달라짐
class PolicyDetailScreen extends StatelessWidget {
  final int policyId;

  const PolicyDetailScreen({super.key, required this.policyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 상세'),
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
              // 에러 로그 출력
              print('PolicyDetailScreen Error: ${snapshot.error}');
              return const Center(child: Text('정책 정보를 불러오는데 실패했습니다.'));
            }

            // 데이터가 있는 경우
            if (snapshot.hasData) {
              final policy = snapshot.data!;
              // 데이터 로그 출력
              print('PolicyDetailScreen Data: ${policy.policyName}');
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
                      const SizedBox(height: 16),
                      buildSection('지원 규모', policy.policySupportScale),
                      buildSection('지원 기간',
                          '${policy.policyStartDate} ~ ${policy.policyEndDate}'),
                      buildSection('주관 기관', policy.policyMainOrganization),
                      buildSection('운영 기관', policy.policyOperationOrganization),
                      buildSection('지원 지역', policy.policyArea),
                      buildSection('대상 연령', policy.policyAgeInfo),
                      buildSection('학력 요건', policy.policyEducationRequirements),
                      buildSection('전공 요건', policy.policyMajorRequirements),
                      buildSection('고용 상태', policy.policyEmploymentStatus),
                      buildSection('공식 웹사이트', policy.policySiteAddress),
                      buildSection('지원 내용', policy.policySupportContent),
                      buildSection('신청 제한', policy.policyEntryLimit),
                      buildSection('신청 절차', policy.policyApplicationProcedure),
                      buildSection('기타 정보', policy.policyEtc),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(color: Colors.grey.shade800)),
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
    );
  }
}
