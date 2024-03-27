package com.e102.simcheonge_server.domain.post.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostDetailResponse {
    private int postId;
    private String postName;
    private String postContent;
    private String userNickname;
    private LocalDateTime createdAt;
    private String categoryName;
}
