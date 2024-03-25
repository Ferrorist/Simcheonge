package com.e102.simcheonge_server.domain.auth.jwt;

import com.e102.simcheonge_server.domain.auth.constants.SecurityConstants;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Date;


@AllArgsConstructor
public class JwtProvider {
    private final JwtUtil jwtUtil;

    // JWT 액세스 토큰 생성 메서드
    public String generateAccessToken(String userLoginId) {
        byte[] signingKey = jwtUtil.getSecretKey().getBytes();

        return Jwts.builder()
                .signWith(Keys.hmacShaKeyFor(signingKey), Jwts.SIG.HS512)
                .header()
                .add("typ", SecurityConstants.TOKEN_TYPE)
                .and()
                .expiration(new Date(System.currentTimeMillis() + 864000000))
                .claim("uid", userLoginId)
                .compact();
    }


    // JWT 액세스 토큰 생성 메서드
    public String generateRefreshToken(String userLoginId) {
        byte[] signingKey = jwtUtil.getSecretKey().getBytes();

        return Jwts.builder()
                .signWith(Keys.hmacShaKeyFor(signingKey), Jwts.SIG.HS512)
                .header()
                .add("typ", SecurityConstants.TOKEN_TYPE)
                .and()
                .expiration(new Date(System.currentTimeMillis() + 864000000))
                .claim("uid", userLoginId)
                .compact();
    }

}



