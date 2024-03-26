package com.e102.simcheonge_server.domain.post.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.category.service.CategoryService;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.post.dto.request.PostRequest;
import com.e102.simcheonge_server.domain.post.dto.response.PostResponse;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.service.PostService;
import com.e102.simcheonge_server.domain.user.dto.SessionUser;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
//import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/posts")
@Slf4j
public class PostController {
    private final PostService postService;
    private final UserRepository userRepository;
    private final CategoryService categoryService;

    @Autowired
    public PostController(PostService postService, UserRepository userRepository, CategoryService categoryService) {
        this.postService = postService;
        this.userRepository = userRepository;
        this.categoryService = categoryService;
    }

    // 게시글 등록
    @PostMapping
    public ResponseEntity<?> createPost(@RequestBody PostRequest postRequest, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        log.info("postRequest={}",postRequest.getPostContent());

            Post savedPost = postService.createPost(postRequest, postRequest.getCategoryCode(), postRequest.getCategoryNumber(), loginUser.getUserId());
            Map<String, Object> responseBody = new HashMap<>();
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, savedPost.getPostId());
    }

    // 게시글 조회
    @GetMapping
    public ResponseEntity<?> getPosts(@RequestParam(value = "category_code", required = true) String categoryCode, @RequestParam(value = "category_number", required = true) Integer categoryNumber, @RequestParam(value = "keyword", required = false) String keyword) {
        List<PostResponse> postResponses = postService.findPostsByCategoryCodeAndNumberWithKeyword(categoryCode, categoryNumber, keyword); // 메서드 이름을 수정했습니다.
        return ResponseEntity.ok(Map.of("status", 200, "data", postResponses));
    }




    // 게시글 삭제
    @DeleteMapping("/{postId}")
    public ResponseEntity<?> deletePost(@PathVariable("postId") int postId, @SessionAttribute(name = "user", required = false) SessionUser loginUser) {
        if (loginUser == null) {
            return ResponseUtil.buildBasicResponse(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        postService.deletePost(postId, loginUser.getUserId());

        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글 삭제에 성공했습니다.");
    }

}
