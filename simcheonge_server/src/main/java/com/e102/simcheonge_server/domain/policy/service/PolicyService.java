package com.e102.simcheonge_server.domain.policy.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.policy.dto.response.PolicyThumbnailResponse;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@Slf4j
public class PolicyService {
    private final PolicyRepository policyRepository;
    private final UserRepository userRepository;
    public PolicyThumbnailResponse getPolicy(int policyId, int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        Policy policy=policyRepository.findByPolicyId(policyId)
                .orElseThrow(()->new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        String title=policy.getName();
        PolicyThumbnailResponse thumbnailResponse=PolicyThumbnailResponse.builder()
                .title(title)
                .build();
        return thumbnailResponse;
    }
}
