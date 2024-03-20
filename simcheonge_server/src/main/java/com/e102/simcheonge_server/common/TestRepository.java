package com.e102.simcheonge_server.common;

import com.e102.simcheonge_server.common.TestEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TestRepository extends JpaRepository<TestEntity, Long> {
}
