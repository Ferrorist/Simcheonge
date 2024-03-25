package com.e102.simcheonge_server.domain.auth.jwt;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import lombok.Data;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.security.core.userdetails.UserDetailsService;


// 해당 클래스는 Spring Boot의 `@ConfigurationProperties`
// 어노테이션을 사용하여, application.properties(속성 설정 파일) 로부터
// JWT 관련 프로퍼티를 관리하는 프로퍼티 클래스입니다.
@Data
@Component
@ConfigurationProperties(prefix = "com.e102.simcheonge-server")
public class JwtUtil {

    // com.e102.simcheonge_server.secretKey로 지정된 프로퍼티 값을 주입받는 필드
    // com.e102.simcheonge_server.secret-key ➡ secretKey : {인코딩된 시크릿 키}
    private String secretKey;
    private final UserDetailsService userDetailsService;


    public String getToken() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
                .getRequest();
        String token = request.getHeader("Authorization");
        return token;
    }

    public Claims parseClaims(String header) {

        String jwt = header.substring(7); // "Bearer " + jwt  ➡ jwt 추출
        byte[] signingKey = this.secretKey.getBytes();

        return Jwts.parser()
                .verifyWith(Keys.hmacShaKeyFor(signingKey))
                .build()
                .parseSignedClaims(jwt)
                .getPayload();
    }

    // access token을 이용해 유저의 ID 찾기
    public String getUserID(String accessToken) {
        // 토큰 복호화
        Claims claims = parseClaims(accessToken);

        String userID = claims.getSubject();
        return userID;
    }

    public Authentication getAuthentication(String token) {
        UserDetails userDetails = userDetailsService.loadUserByUsername(this.getUserID(token));
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }
}