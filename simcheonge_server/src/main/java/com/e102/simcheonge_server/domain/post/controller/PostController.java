package com.e102.simcheonge_server.domain.post.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.category.service.CategoryService;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.post.dto.request.PostRequest;
import com.e102.simcheonge_server.domain.post.dto.response.MyPostResponse;
import com.e102.simcheonge_server.domain.post.dto.response.PostDetailResponse;
import com.e102.simcheonge_server.domain.post.dto.response.PostResponse;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.service.PostService;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import com.e102.simcheonge_server.domain.user.utill.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
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
    public ResponseEntity<?> createPost(@RequestBody PostRequest postRequest, @AuthenticationPrincipal UserDetails userDetails){
        User user = UserUtil.getUserFromUserDetails(userDetails);
        log.info("postRequest={}",postRequest.getPostContent());

            Post savedPost = postService.createPost(postRequest, postRequest.getCategoryCode(), postRequest.getCategoryNumber(), user.getUserId());
            Map<String, Object> responseBody = new HashMap<>();
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, Map.of("post_id",savedPost.getPostId()));
    }

    // 게시글 조회
    @GetMapping
    public ResponseEntity<?> getPosts(@RequestParam(value = "category_code", required = true) String categoryCode, @RequestParam(value = "category_number", required = true) Integer categoryNumber, @RequestParam(value = "keyword", required = false) String keyword) {
        List<PostResponse> postResponses = postService.findPostsByCategoryCodeAndNumberWithKeyword(categoryCode, categoryNumber, keyword); // 메서드 이름을 수정했습니다.
        return ResponseEntity.ok(Map.of("status", 200, "data", postResponses));
    }

    // 게시글 수정
    @PatchMapping("/{postId}")
    public ResponseEntity<?> updatePost(@PathVariable("postId") int postId, @RequestBody PostRequest postRequest, @AuthenticationPrincipal UserDetails userDetails){
        User user = UserUtil.getUserFromUserDetails(userDetails);
        if (user == null) {
            return ResponseUtil.buildBasicResponse(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        postService.updatePost(postId, postRequest, user.getUserId());

        return ResponseUtil.buildBasicResponse(HttpStatus.OK, Map.of("post_id", postId));
    }

    // 게시글 삭제
    @DeleteMapping("/{postId}")
    public ResponseEntity<?> deletePost(@PathVariable("postId") int postId, @AuthenticationPrincipal UserDetails userDetails){
        User user = UserUtil.getUserFromUserDetails(userDetails);
        if (user == null) {
            return ResponseUtil.buildBasicResponse(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        postService.deletePost(postId, user.getUserId());

        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글 삭제에 성공했습니다.");
    }

    // 게시글 상세 조회
    @GetMapping("/{postId}")
    public ResponseEntity<?> getPostDetail(@PathVariable("postId") int postId, @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        PostDetailResponse postDetail = postService.findPostDetailById(postId);
        return ResponseEntity.ok(Map.of("status", 200, "data", postDetail));
    }

    // 내가 쓴 게시글 조회
    @GetMapping("/my")
    public ResponseEntity<?> getMyPosts(
            @RequestParam("category_code") String categoryCode,
            @RequestParam("category_number") Integer categoryNumber,
            @AuthenticationPrincipal UserDetails userDetails) {

        // UserDetails에서 유저 아이디 추출
        User user = UserUtil.getUserFromUserDetails(userDetails);
        if (user == null) {
            return ResponseUtil.buildBasicResponse(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        // 게시글 조회 서비스 호출
        List<MyPostResponse> myPosts = postService.findMyPostsByCategoryCodeAndNumber(user.getUserId(), categoryCode, categoryNumber);

        return ResponseEntity.ok(Map.of("status", HttpStatus.OK.value(), "data", myPosts));
    }


}
