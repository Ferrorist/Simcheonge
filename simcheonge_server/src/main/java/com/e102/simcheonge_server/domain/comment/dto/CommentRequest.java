package com.e102.simcheonge_server.domain.comment.dto;

import lombok.Data;

@Data
public class CommentRequest {
    String commentType;
    int referencedId;
    String content;
}
