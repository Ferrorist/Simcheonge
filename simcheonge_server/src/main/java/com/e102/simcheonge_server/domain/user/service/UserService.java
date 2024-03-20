package com.e102.simcheonge_server.domain.user.service;

import com.e102.simcheonge_server.common.exception.AuthenticationException;
import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.user.dto.SessionUser;
import com.e102.simcheonge_server.domain.user.dto.request.LoginReqeust;
import com.e102.simcheonge_server.domain.user.dto.request.SignUpRequest;
import com.e102.simcheonge_server.domain.user.dto.response.LoginResponse;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Slf4j
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final HttpSession httpSession;

    @Transactional
    public void saveUser(final SignUpRequest signUpRequestForm){
        isValidateLoginId(signUpRequestForm.getUserLoginId());
        isValidateNickname(signUpRequestForm.getUserNickname());
        isValidatePassword(signUpRequestForm.getUserPassword(), signUpRequestForm.getUserPasswordCheck());

        User user=User.builder()
                .userLoginId(signUpRequestForm.getUserLoginId())
                .userPassword(signUpRequestForm.getUserPassword())
                .userNickname(signUpRequestForm.getUserNickname())
                .build();
        userRepository.save(user);
    }

    private void isValidatePassword(String password, String passwordCheck) {
        if (!password.equals(passwordCheck)) {
            throw new IllegalArgumentException("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        }
    }

    public void isValidateLoginId(String userLoginId) {
        Optional<User> user = userRepository.findByUserLoginId(userLoginId);
        if (user.isPresent()) {
            throw new IllegalArgumentException("이미 존재하는 아이디 입니다.");
        }
    }

    public void isValidateNickname(String nickname) {
        Optional<User> user = userRepository.findByUserNickname(nickname);
        if (user.isPresent()) {
            throw new IllegalArgumentException("이미 존재하는 닉네임 입니다.");
        }
    }

    public LoginResponse login(LoginReqeust loginRequest) {
        Optional<User> userOptional = userRepository.findByUserLoginId(loginRequest.getUserLoginId());
        if (userOptional.isEmpty()) {
            throw new AuthenticationException("사용자를 찾을 수 없습니다.");
        }
        User user = userOptional.get();
        if (!user.getUserPassword().equals(loginRequest.getUserPassword())) {
            throw new AuthenticationException("해당 비밀번호가 일치하지 않습니다.");
        }

        // 성공적으로 로그인한 경우 세션에 사용자 정보를 설정하고 응답을 반환합니다.
        httpSession.setAttribute("user", new SessionUser(user));

        return LoginResponse.builder()
                .userId(user.getUserId())
                .userLoginId(user.getUserLoginId())
                .userNickname(user.getUserNickname())
                .build();
    }

    @Transactional
    public void updateNickname(final String userNickname,final int userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        isValidateNickname(userNickname);
        user.updateNickname(userNickname);
        userRepository.save(user);
    }

    @Transactional
    public void updatePassword(final String userPassword,final int userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        user.updatePassword(userPassword);
        userRepository.save(user);
    }
}
