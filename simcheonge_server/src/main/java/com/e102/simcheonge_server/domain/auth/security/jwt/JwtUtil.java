package com.e102.simcheonge_server.domain.auth.security.jwt;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * [JWT 관련 메서드를 제공하는 클래스]
 */
@Slf4j
@Component
@Data
@ConfigurationProperties(prefix = "com.e102.simcheonge-server")
public class JwtUtil {

    private String secretKey;

}