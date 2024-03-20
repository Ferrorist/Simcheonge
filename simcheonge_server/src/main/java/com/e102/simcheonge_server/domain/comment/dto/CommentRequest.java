package com.e102.simcheonge_server.domain.comment.dto;

import lombok.Data;

@Data
public class CommentRequest {
    int commentId;
    String commentType;
    int postId;
    int policyId;
    String content;
}
