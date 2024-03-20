package com.e102.simcheonge_server.domain.post.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.post.dto.PostRequest;
import com.e102.simcheonge_server.domain.post.dto.PostResponse;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/posts")
public class PostController {
    private final PostService postService;

    @Autowired
    public PostController(PostService postService) {
        this.postService = postService;
    }

    // 게시글 조회
    @GetMapping
    public ResponseEntity<?> getPosts(@RequestParam(required = false) String categoryCode, @RequestParam(required = false) String keyword) {
        if (keyword != null) {
            // 검색 로직
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, postService.searchPosts(keyword));
        } else {
            // 카테고리 기반 조회 또는 전체 조회
            String actualCategoryCode = categoryCode != null ? categoryCode : "전체";
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, postService.findPostsByCategory(actualCategoryCode));
        }
    }

    // 게시글 등록
    @PostMapping
    public ResponseEntity<?> createPost(@RequestBody PostRequest postRequest) {
        // 인증 정보에서 userId 추출 로직 필요
        Post post = Post.builder()
                .postName(postRequest.getPostName())
                .postContent(postRequest.getPostContent())
                // .userId(userId) // 실제 인증 정보를 통해 userId 설정
                .build();
        Post savedPost = postService.createPost(post, postRequest.getCategoryCode());
        return ResponseUtil.buildBasicResponse(HttpStatus.CREATED, new PostResponse(savedPost));
    }

    // 게시글 삭제
    @DeleteMapping("/{post_id}")
    public ResponseEntity<?> deletePost(@PathVariable("post_id") int postId) {
        // 인증 정보 확인 및 소유권 검사 로직 필요
        postService.deletePost(postId);
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글이 삭제되었습니다.");
    }

    // 게시글 수정
    @PatchMapping("/{post_id}")
    public ResponseEntity<?> updatePost(@PathVariable("post_id") int postId, @RequestBody PostRequest postRequest) {
        // 인증 정보 확인 및 소유권 검사 로직 필요
        Post updatedPost = postService.updatePost(postId, postRequest.getPostName(), postRequest.getPostContent());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, new PostResponse(updatedPost));
    }

    // 게시글 상세 조회
    @GetMapping("/{post_id}")
    public ResponseEntity<?> getPostDetail(@PathVariable("post_id") int postId) {
        Optional<Post> post = postService.findPostById(postId);
        if (post.isPresent()) {
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, new PostResponse(post.get()));
        } else {
            return ResponseUtil.buildErrorResponse(HttpStatus.NOT_FOUND, "Not Found", "게시글을 찾을 수 없습니다.");
        }
    }

    // 내가 쓴 게시글 조회 (URL 및 로직 수정 필요)
    @GetMapping("/my")
    public ResponseEntity<?> getMyPosts(/* 인증 정보 파라미터 */) {
        // 인증 정보에서 userId 추출 로직 필요
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, postService.findPostsByUserId(/* userId */));
    }
}
