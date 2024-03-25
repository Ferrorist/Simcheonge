package com.e102.simcheonge_server.domain.post.dto.response;


import java.time.LocalDateTime;
import java.util.Date;

public class PostResponse {

    private int postId;
    private String postName;
    private String postContent;
    private String userNickname;
    private Date createdAt;
    private String categoryName;

    // Constructors, Getters, and Setters

    public PostResponse(int postId, String postName, String postContent, String userNickname, Date createdAt, String categoryName) {
        this.postId = postId;
        this.postName = postName;
        this.postContent = postContent;
        this.userNickname = userNickname;
        this.createdAt = createdAt;
        this.categoryName = categoryName;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getPostName() {
        return postName;
    }

    public void setPostName(String postName) {
        this.postName = postName;
    }

    public String getPostContent() {
        return postContent;
    }

    public void setPostContent(String postContent) {
        this.postContent = postContent;
    }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
