package com.e102.simcheonge_server.domain.comment.controller;

import com.e102.simcheonge_server.domain.comment.dto.CommentRequest;
import com.e102.simcheonge_server.domain.comment.service.CommentService;
import com.e102.simcheonge_server.domain.user.dto.SessionUser;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequestMapping("/comment")
@AllArgsConstructor
public class CommentController {
    private final CommentService commentService;

    @PostMapping("/")
    public ResponseEntity<?> addComment(@RequestBody CommentRequest commentRequest, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser){
        commentService.addComment(commentRequest, loginUser.getUserId());
        return ResponseEntity.ok("댓글 등록에 성공했습니다.");
    }

}
