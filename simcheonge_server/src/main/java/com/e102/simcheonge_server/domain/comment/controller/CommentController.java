package com.e102.simcheonge_server.domain.comment.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.comment.dto.request.CommentCreateRequest;
import com.e102.simcheonge_server.domain.comment.dto.request.CommentReadRequest;
import com.e102.simcheonge_server.domain.comment.service.CommentService;
import com.e102.simcheonge_server.domain.user.dto.SessionUser;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequestMapping("/comment")
@AllArgsConstructor
public class CommentController {
    private final CommentService commentService;

    @PostMapping
    public ResponseEntity<?> addComment(@RequestBody CommentCreateRequest commentRequest, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        commentService.addComment(commentRequest, loginUser.getUserId());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "댓글 등록에 성공했습니다.");
    }

    @GetMapping("/{commentType}/{referencedId}")
    public ResponseEntity<?> getBoardComments(@PathVariable("commentType") String commentType, @PathVariable("referencedId") int referencedId, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, commentService.getBoardComments(commentType, referencedId, loginUser.getUserId()));
    }

    @GetMapping("/{commentType}")
    public ResponseEntity<?> getMyComments(@PathVariable("commentType") String commentType, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, commentService.getMyComments(commentType, loginUser.getUserId()));
    }

    @GetMapping("/{commentType}/search")
    public ResponseEntity<?> searchMyComments(@PathVariable("commentType") String commentType, @RequestParam(name="keyword", required = true) String keyword, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, commentService.searchMyComments(commentType, keyword, loginUser.getUserId()));
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<?> deleteComment(@PathVariable("commentId") int commentId, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        commentService.deleteComment(commentId, loginUser.getUserId());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "댓글 삭제에 성공했습니다.");
    }

}
