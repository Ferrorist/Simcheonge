package com.e102.simcheonge_server.domain.auth.service;

import com.e102.simcheonge_server.common.exception.AuthenticationException;
import com.e102.simcheonge_server.domain.auth.dto.request.LoginReqeust;
import com.e102.simcheonge_server.domain.auth.dto.response.LoginResponse;
import com.e102.simcheonge_server.domain.auth.jwt.JwtUtil;
import com.e102.simcheonge_server.domain.auth.jwt.JwtProvider;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


import java.util.Optional;

@Service
@Slf4j
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final JwtProvider jwtProvider;

    public LoginResponse login(LoginReqeust loginRequest) {

        Optional<User> userOptional = userRepository.findByUserLoginId(loginRequest.getUserLoginId());
        if (userOptional.isEmpty()) {
            throw new AuthenticationException("사용자를 찾을 수 없습니다.");
        }
        User user = userOptional.get();
        if (!user.getUserPassword().equals(loginRequest.getUserPassword())) {
            throw new AuthenticationException("해당 비밀번호가 일치하지 않습니다.");
        }

        String accessToken = jwtProvider.generateAccessToken(user.getUserLoginId());
        String refreshToken = jwtProvider.generateRefreshToken(user.getUserLoginId());


        return LoginResponse.builder()
                .userID(user.getUserId())
                .userLoginId(user.getUserLoginId())
                .userNickname(user.getUserNickname())
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();

    }

}
