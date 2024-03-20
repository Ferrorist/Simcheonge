package com.e102.simcheonge_server.domain.user.dto;


import com.e102.simcheonge_server.domain.user.entity.User;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;

import java.io.Serializable;

@Getter
public class SessionUser implements Serializable {

    private int userId;
    private String userLoginId;
    private String nickname;


    SessionUser(){};

    public SessionUser(User user) {
        this.userId=user.getUserId();
        this.userLoginId=user.getUserLoginId();
        this.nickname=user.getUserNickname();
    }

//    public SessionUser(@JsonProperty("userId") int userId,
//                       @JsonProperty("userLoginId") String userLoginId,
//                       @JsonProperty("nickname") String nickname) {
//        this.userId = userId;
//        this.userLoginId = userLoginId;
//        this.nickname = nickname;
//    }
}
