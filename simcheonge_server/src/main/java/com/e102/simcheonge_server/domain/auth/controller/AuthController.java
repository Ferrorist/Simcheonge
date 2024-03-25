package com.e102.simcheonge_server.domain.auth.controller;


import com.e102.simcheonge_server.domain.auth.dto.response.LoginResponse;
import com.e102.simcheonge_server.domain.auth.service.AuthService;
import com.e102.simcheonge_server.domain.auth.dto.request.LoginRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequiredArgsConstructor
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public LoginResponse signIn(@RequestBody LoginRequest loginRequest) {
        return authService.login(loginRequest);
    }
}