package com.e102.simcheonge_server.domain.post.entity;

import com.e102.simcheonge_server.common.BaseEntity;
import com.e102.simcheonge_server.domain.user.entity.User;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.util.Date;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Table(name = "post")
public class Post extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private int postId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    @NotNull
    private User userId;

    @Column(name = "post_name", length = 400, nullable = false)
    private String postName;

    @Column(name = "post_content", length = 6000, nullable = false)
    private String postContent;

}
