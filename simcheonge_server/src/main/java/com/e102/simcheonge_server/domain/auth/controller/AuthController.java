package com.e102.simcheonge_server.domain.auth.controller;

import com.e102.simcheonge_server.domain.auth.service.AuthService;
import com.e102.simcheonge_server.domain.auth.dto.request.LoginReqeust;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lombok.extern.slf4j.Slf4j;

import static com.e102.simcheonge_server.common.util.ResponseUtil.buildBasicResponse;


@RestController
@AllArgsConstructor
@Slf4j
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginReqeust loginInReqeust){
        log.info("signUpRequestForm={}",loginInReqeust);
        return buildBasicResponse(HttpStatus.OK, authService.login(loginInReqeust));
    }

}


//    @PostMapping("/logout")
//    public ResponseEntity<?> logout(@SessionAttribute(name = "user", required = false)
//                                    SessionUser loginUser){
//        httpSession.removeAttribute("user");
//        return buildBasicResponse(HttpStatus.OK,"로그아웃에 성공했습니다.");
//    }
