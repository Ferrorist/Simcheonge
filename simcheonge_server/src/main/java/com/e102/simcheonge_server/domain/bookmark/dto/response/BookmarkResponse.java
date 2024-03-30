package com.e102.simcheonge_server.domain.bookmark.dto.response;

public class BookmarkResponse {
    private int bookmarkId;
    private int userId;
    private int referencedId;
    private String bookmarkType;

    // 기본 생성자
    public BookmarkResponse() {
    }

    // 모든 필드를 초기화하는 생성자
    public BookmarkResponse(int bookmarkId, int userId, int referencedId, String bookmarkType) {
        this.bookmarkId = bookmarkId;
        this.userId = userId;
        this.referencedId = referencedId;
        this.bookmarkType = bookmarkType;
    }

    public int getBookmarkId() {
        return bookmarkId;
    }

    public void setBookmarkId(int bookmarkId) {
        this.bookmarkId = bookmarkId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getReferencedId() {
        return referencedId;
    }

    public void setReferencedId(int referencedId) {
        this.referencedId = referencedId;
    }

    public String getBookmarkType() {
        return bookmarkType;
    }

    public void setBookmarkType(String bookmarkType) {
        this.bookmarkType = bookmarkType;
    }
}
