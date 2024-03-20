package com.e102.simcheonge_server.domain.user.repository;

import com.e102.simcheonge_server.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepostory extends JpaRepository<User, Integer> {
    Optional<User> findByUserId(int userId);
}
