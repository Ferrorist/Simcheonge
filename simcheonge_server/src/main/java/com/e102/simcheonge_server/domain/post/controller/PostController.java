package com.e102.simcheonge_server.domain.post.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.post.dto.PostRequest;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.service.PostService;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/posts")
public class PostController {
    private final PostService postService;
    private final UserRepository userRepository;

    @Autowired
    public PostController(PostService postService, UserRepository userRepository) {
        this.postService = postService;
        this.userRepository = userRepository;
    }

    // 게시글 조회
    @GetMapping
    public ResponseEntity<?> getPosts(@RequestParam(value = "category_code", required = false, defaultValue = "POS") String categoryCode,
                                        @RequestParam(value = "category_number", required = false) Integer categoryNumber,
                                        @RequestParam(value = "keyword", required = false) String keyword) {
        if (keyword != null && !keyword.isEmpty()) {
            List<Post> posts = postService.searchPosts(keyword);
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, posts);
        } else {
            List<Post> posts = postService.findPostsByCategoryAndKeyword(categoryCode, categoryNumber, keyword);
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, posts);
        }
    }

    // 게시글 등록
    @PostMapping
    public ResponseEntity<?> createPost(@AuthenticationPrincipal UserDetails userDetails,
                                        @RequestBody PostRequest postRequest) {
        Optional<User> userOptional = userRepository.findByUserLoginId(userDetails.getUsername());
        if (userOptional.isPresent()) {
            Post post = Post.builder()
                    .userId(userOptional.get().getUserId())
                    .postName(postRequest.getPostName())
                    .postContent(postRequest.getPostContent())
                    .build();

            post = postService.createPost(post, postRequest.getCategoryCode(), postRequest.getCategoryNumber());
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글이 등록되었습니다.");
        } else {
            return ResponseUtil.buildErrorResponse(HttpStatus.UNAUTHORIZED, "Unauthorized", "사용자 인증 실패");
        }
    }

    // 게시글 삭제
    @DeleteMapping("/{post_id}")
    public ResponseEntity<?> deletePost(@AuthenticationPrincipal UserDetails userDetails,
                                        @PathVariable("post_id") int postId) {
        Optional<User> userOptional = userRepository.findByUserLoginId(userDetails.getUsername());
        if (userOptional.isPresent() && postService.findPostById(postId).map(Post::getUserId).orElse(-1) == userOptional.get().getUserId()) {
            postService.deletePost(postId);
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글이 삭제되었습니다.");
        } else {
            return ResponseUtil.buildErrorResponse(HttpStatus.FORBIDDEN, "Forbidden", "게시글 삭제 권한이 없습니다.");
        }
    }

    // 게시글 수정
    @PatchMapping("/{post_id}")
    public ResponseEntity<?> updatePost(@AuthenticationPrincipal UserDetails userDetails,
                                        @PathVariable("post_id") int postId,
                                        @RequestBody PostRequest postRequest) {
        Optional<User> userOptional = userRepository.findByUserLoginId(userDetails.getUsername());
        if (userOptional.isPresent()) {
            Post updatedPost = postService.updatePost(postId, postRequest.getPostName(), postRequest.getPostContent());
            if (updatedPost != null) {
                return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글이 수정되었습니다.");
            } else {
                return ResponseUtil.buildErrorResponse(HttpStatus.NOT_FOUND, "Not Found", "해당 게시글을 찾을 수 없습니다.");
            }
        } else {
            return ResponseUtil.buildErrorResponse(HttpStatus.FORBIDDEN, "Forbidden", "게시글 수정 권한이 없습니다.");
        }
    }

    // 게시글 상세 조회
    @GetMapping("/{post_id}")
    public ResponseEntity<?> getPostDetails(@PathVariable("post_id") int postId) {
        Optional<Post> postOptional = postService.findPostById(postId);
        if (postOptional.isPresent()) {
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, postOptional.get());
        } else {
            return ResponseUtil.buildErrorResponse(HttpStatus.NOT_FOUND, "Not Found", "해당 게시글을 찾을 수 없습니다.");
        }
    }

    // 내가 쓴 게시글 조회
    @GetMapping("/{user_id}")
    public ResponseEntity<?> getMyPosts(@AuthenticationPrincipal UserDetails userDetails) {
        Optional<User> userOptional = userRepository.findByUserLoginId(userDetails.getUsername());
        if (userOptional.isPresent()) {
            List<Post> myPosts = postService.findPostsByUserId(userOptional.get().getUserId());
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, myPosts);
        } else {
            return ResponseUtil.buildErrorResponse(HttpStatus.UNAUTHORIZED, "Unauthorized", "사용자 인증 실패");
        }
    }
}
