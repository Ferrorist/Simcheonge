package com.e102.simcheonge_server.domain.bookmark.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookmarkCreateRequest {
    private String bookmarkType; // "POL" 또는 "POS"
    private Integer policyId; // Optional, 정책 ID
    private Integer postId; // Optional, 게시글 ID

    // Getters and Setters
}
