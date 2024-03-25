package com.e102.simcheonge_server.domain.auth.jwt;

import io.jsonwebtoken.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtValidator {
    private final JwtUtil jwtUtil;

    public Boolean validateToken(String header) {
        try {
            String jwt = header.substring(7); // "Bearer " + jwt  ➡ jwt 추출

            byte[] signingKey = jwtUtil.getSecretKey().getBytes();

            // 토큰의 서명을 확인하여 변조 여부를 검사
            Jws<Claims> parsedToken = Jwts.parser()
                    .verifyWith(Keys.hmacShaKeyFor(signingKey))
                    .build()
                    .parseSignedClaims(jwt);

            return true; // 토큰 유효성 검증 성공
        } catch (SecurityException | MalformedJwtException e){
//            "잘못된 JWT 서명입니다."
            return false;

        } catch(ExpiredJwtException e){
//            "만료된 JWT 토큰입니다."
            return false;

        } catch(UnsupportedJwtException e){
//            "지원되지 않는 JWT 토큰입니다."

            return false;

        } catch(IllegalArgumentException e){
//            "JWT 토큰이 잘못되었습니다."
            return false;
        }
    }


}