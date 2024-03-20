package com.e102.simcheonge_server.domain.comment.controller;

import com.e102.simcheonge_server.domain.comment.dto.CommentRequest;
import com.e102.simcheonge_server.domain.comment.service.CommentService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequestMapping("/comment")
@AllArgsConstructor
public class CommentController {
    private final CommentService commentService;

    @PostMapping("/")
    public ResponseEntity<?> addComment(@RequestBody CommentRequest commentRequest, int userId){
//        commentService.addComment(commentRequest, userId);
        return ResponseEntity.ok("댓글 등록에 성공했습니다.");
    }

}
