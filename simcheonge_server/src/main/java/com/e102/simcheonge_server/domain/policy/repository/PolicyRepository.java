package com.e102.simcheonge_server.domain.policy.repository;

import com.e102.simcheonge_server.domain.policy.entity.Policy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PolicyRepository extends JpaRepository<Policy,Integer> {
    Optional<Policy> findByPolicyId(int policyId);
}
