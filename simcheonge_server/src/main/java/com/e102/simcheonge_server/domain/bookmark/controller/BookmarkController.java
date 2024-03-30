package com.e102.simcheonge_server.domain.bookmark.controller;

import com.e102.simcheonge_server.domain.bookmark.dto.request.BookmarkCreateRequest;
import com.e102.simcheonge_server.domain.bookmark.dto.response.BookmarkResponse;
import com.e102.simcheonge_server.domain.bookmark.service.BookmarkService;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.utill.UserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/bookmarks")
public class BookmarkController {
    private final BookmarkService bookmarkService;

    @Autowired
    public BookmarkController(BookmarkService bookmarkService) {
        this.bookmarkService = bookmarkService;
    }

    // 북마크 등록
    @PostMapping
    public ResponseEntity<?> createBookmark(@RequestBody BookmarkCreateRequest request, @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("인증이 필요합니다.");
        }

        User user = UserUtil.getUserFromUserDetails(userDetails);
        BookmarkResponse response = bookmarkService.createBookmark(request, user.getUserId());

        Map<String, Object> responseBody = new LinkedHashMap<>();
        responseBody.put("status", HttpStatus.OK.value());
        responseBody.put("data", "북마크가 등록되었습니다.");
        responseBody.put("bookmark_id", response.getBookmarkId());

        return new ResponseEntity<>(responseBody, HttpStatus.OK);
    }
}
