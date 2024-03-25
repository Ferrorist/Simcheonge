package com.e102.simcheonge_server.domain.auth.filter;

import com.e102.simcheonge_server.domain.auth.jwt.JwtProvider;
import com.e102.simcheonge_server.domain.auth.jwt.JwtUtil;
import com.e102.simcheonge_server.domain.auth.jwt.JwtValidator;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.GenericFilterBean;

import java.io.IOException;

@RequiredArgsConstructor
public class JwtAuthenticationFilter extends GenericFilterBean {

    private final JwtProvider jwtProvider;
    private final JwtValidator jwtValidator;
    private final JwtUtil jwtUtil;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        // 토큰을 추출
        String token = jwtUtil.getToken();

        if (token != null && jwtValidator.validateToken(token)) {

            // 유효성 검증 이후 토큰을 context에 저장
            Authentication authentication = jwtUtil.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        chain.doFilter(request, response);

    }

}
