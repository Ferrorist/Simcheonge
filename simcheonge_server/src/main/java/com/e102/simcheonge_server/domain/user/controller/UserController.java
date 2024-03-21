package com.e102.simcheonge_server.domain.user.controller;

import com.e102.simcheonge_server.domain.user.dto.SessionUser;
import com.e102.simcheonge_server.domain.user.dto.request.LoginReqeust;
import com.e102.simcheonge_server.domain.user.dto.request.SignUpRequest;
import com.e102.simcheonge_server.domain.user.dto.request.UpdateNicknameRequest;
import com.e102.simcheonge_server.domain.user.dto.request.UpdatePasswordRequest;
import com.e102.simcheonge_server.domain.user.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import static com.e102.simcheonge_server.common.util.ResponseUtil.buildBasicResponse;

@RestController
@AllArgsConstructor
@Slf4j
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;
    private final HttpSession httpSession;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignUpRequest signUpRequestForm){
        log.info("signUpRequestForm={}",signUpRequestForm);
        userService.saveUser(signUpRequestForm);
        return buildBasicResponse(HttpStatus.OK,"회원 가입에 성공했습니다.");
    }


    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginReqeust loginInReqeust){
        log.info("signUpRequestForm={}",loginInReqeust);
        return buildBasicResponse(HttpStatus.OK,userService.login(loginInReqeust));
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(@SessionAttribute(name = "user", required = false)
                                       SessionUser loginUser){
        httpSession.removeAttribute("user");
        return buildBasicResponse(HttpStatus.OK,"로그아웃에 성공했습니다.");
    }

    @GetMapping("/userInfo")
    public ResponseEntity<?> getInfo(@SessionAttribute(name = "user", required = false)
                                         SessionUser loginUser){
        log.info("sessionUser={}",loginUser.getUserId());
        return buildBasicResponse(HttpStatus.OK,loginUser.getUserId());
    }

    @GetMapping("/check-nickname/{userNickname}")
    public ResponseEntity<?> checkNickname(@PathVariable("userNickname") String userNickname) {
        userService.isValidateNickname(userNickname);
        return buildBasicResponse(HttpStatus.OK,"해당 닉네임은 사용 가능합니다.");
    }

    @GetMapping("/check-loginId/{userLoginId}")
    public ResponseEntity<?> checkLoginId(@PathVariable("userLoginId") String userLoginId) {
        userService.isValidateLoginId(userLoginId);
        return buildBasicResponse(HttpStatus.OK,"해당 아이디는 사용 가능합니다.");
    }

    @PatchMapping("/nickname")
    public ResponseEntity<?> updateNickname(@RequestBody UpdateNicknameRequest userNickname, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        userService.updateNickname(userNickname.getUserNickname(),loginUser.getUserId());
        return buildBasicResponse(HttpStatus.OK,"닉네임 변경에 성공했습니다.");
    }

    @PatchMapping("/password")
    public ResponseEntity<?> updatePassword(@RequestBody UpdatePasswordRequest userPassword, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        userService.updatePassword(userPassword.getUserPassword(),loginUser.getUserId());
        return buildBasicResponse(HttpStatus.OK,"비밀번호 변경에 성공했습니다.");
    }
}

