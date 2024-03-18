package com.e102.simcheonge_server.domain.user.entity;

import com.e102.simcheonge_server.common.BaseEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Table(name = "user")
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int userId;

    @Column(name = "user_login_id", length = 16, nullable = false)
    private String userLoginId;

    @Column(name = "user_password", length = 64, nullable = false)
    private String userPassword;

    @Column(name = "user_nickname", length = 16, nullable = false)
    private String userNickname;
}
