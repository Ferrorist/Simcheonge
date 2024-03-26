package com.e102.simcheonge_server.domain.auth.security.jwt;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * [JWT 관련 메서드를 제공하는 클래스]
 */
@Slf4j
@Component
@Data
@ConfigurationProperties(prefix = "com.e102.simcheonge-server")
@AllArgsConstructor
public class JwtUtil {

    private String secretKey;
    private RedisTemplate<String, String> redisTemplate;

    public void saveRefreshToken(String userLoginId, String refreshToken) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set("refreshToken:" + userLoginId, refreshToken, 1, TimeUnit.DAYS); // 1일 동안 유효
    }
    public void invalidateRefreshToken(String userLoginId) {
        redisTemplate.delete("refreshToken:" + userLoginId);
    }

}