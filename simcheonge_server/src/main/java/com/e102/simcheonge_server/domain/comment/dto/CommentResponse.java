package com.e102.simcheonge_server.domain.comment.dto;

import lombok.Data;

@Data
public class CommentResponse {
    int commentId;
    int userId;
    String nickname;
    String content;
    String createAt;
    String commentType;
    boolean isMyComment;
}
