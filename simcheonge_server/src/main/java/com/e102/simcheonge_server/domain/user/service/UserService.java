package com.e102.simcheonge_server.domain.user.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.user.dto.request.SignUpRequest;
import com.e102.simcheonge_server.domain.user.dto.request.UpdatePasswordRequest;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Slf4j
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public void saveUser(final SignUpRequest signUpRequest){
        isValidateLoginId(signUpRequest.getUserLoginId());
        isValidateNickname(signUpRequest.getUserNickname());
        isValidatePassword(signUpRequest.getUserPassword(), signUpRequest.getUserPasswordCheck());


        String hashedPassword = passwordEncoder.encode(signUpRequest.getUserPassword());

        User user=User.builder()
                .userLoginId(signUpRequest.getUserLoginId())
                .userPassword(hashedPassword)
                .userNickname(signUpRequest.getUserNickname())
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

    @Transactional
    public void updateNickname(final String userNickname,final int userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        isValidateNickname(userNickname);
        user.updateNickname(userNickname);
        userRepository.save(user);
    }

    @Transactional
    public void updatePassword(final UpdatePasswordRequest userPassword, final int userId) {

        String currentPassword = userPassword.getCurrentPassword();
        String newPassword = userPassword.getNewPassword();

        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));

        if (!passwordEncoder.matches(currentPassword, user.getUserPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
        }

        String encodedNewPassword = passwordEncoder.encode(newPassword);

        user.updatePassword(encodedNewPassword);
        userRepository.save(user);
    }
}
