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

@Entity
@Table(name = "post")
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Post extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id", nullable = false)
    private int postId;

    @Column(name = "user_id", nullable = false)
    private int userId;

    @Column(name = "post_name", length = 400, nullable = false)
    private String postName;

    @Column(name = "post_content", length = 6000, nullable = false)
    private String postContent;

    // 게시글 제목 설정 메서드
    public void setPostName(String postName) {
        this.postName = postName;
    }

    // 게시글 내용 설정 메서드
    public void setPostContent(String postContent) {
        this.postContent = postContent;
    }

    // 삭제 상태 변경 및 삭제 시간 설정 메서드는 BaseEntity에서 상속받음
}
