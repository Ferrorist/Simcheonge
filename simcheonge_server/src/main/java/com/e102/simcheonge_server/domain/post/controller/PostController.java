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

    // 게시글 조회
//    @GetMapping
//    public ResponseEntity<?> getPosts(@RequestParam(value = "category_code", required = false, defaultValue = "POS") String categoryCode, @RequestParam(value = "category_number") Integer categoryNumber, @RequestParam(value = "keyword", required = false) String keyword) {
//        categoryCode = "POS";
//
//        List<Post> posts;
//        if (keyword != null && !keyword.trim().isEmpty()) {
//            posts = postService.searchPostsByCategoryAndKeyword(categoryCode, categoryNumber, keyword);
//        } else {
//            posts = postService.findPostsByCategory(categoryCode, categoryNumber);
//        }
//
//        String finalCategoryCode = categoryCode;
//        List<Map<String, Object>> response = posts.stream().map(post -> {
//            Map<String, Object> postInfo = new HashMap<>();
//            postInfo.put("post_id", post.getPostId());
//            postInfo.put("post_name", post.getPostName());
//            postInfo.put("post_content", post.getPostContent());
//            userRepository.findById(post.getUserId()).ifPresent(user -> postInfo.put("user_nickname", user.getUserNickname()));
//            categoryService.getCategoryDetails(finalCategoryCode).stream()
//                    .filter(c -> c.getNumber() == categoryNumber)
//                    .findFirst()
//                    .ifPresent(categoryDetail -> postInfo.put("category_name", categoryDetail.getName()));
//            postInfo.put("created_at", post.getCreatedAt());
//            return postInfo;
//        }).collect(Collectors.toList());
//
//        return ResponseEntity.ok(Map.of("status", 200, "data", response));
//    }

    // 게시글 등록
    @PostMapping
    public ResponseEntity<?> createPost(@RequestBody PostRequest postRequest, @SessionAttribute(name = "user", required = false)
    SessionUser loginUser) {
        log.info("postRequest={}",postRequest.getPostContent());

            Post savedPost = postService.createPost(postRequest, postRequest.getCategoryCode(), postRequest.getCategoryNumber(), loginUser.getUserId());
            Map<String, Object> responseBody = new HashMap<>();
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, savedPost.getPostId());
        }
    }




//    // 게시글 삭제
//    @DeleteMapping("/{post_id}")
//    public ResponseEntity<?> deletePost(@AuthenticationPrincipal UserDetails userDetails, @PathVariable("post_id") int postId) {
//        User user = userRepository.findByUserLoginId(userDetails.getUsername())
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "사용자 인증 실패"));
//
//        Post post = postService.findPostById(postId)
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "해당 게시글을 찾을 수 없습니다."));
//
//        if (post.getUserId() != user.getUserId()) {
//            return ResponseUtil.buildErrorResponse(HttpStatus.FORBIDDEN, "Forbidden", "게시글 삭제 권한이 없습니다.");
//        }
//
//        postService.deletePost(postId);
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글이 삭제되었습니다.");
//    }
//
//    // 게시글 수정
//    @PatchMapping("/{post_id}")
//    public ResponseEntity<?> updatePost(@AuthenticationPrincipal UserDetails userDetails,
//                                        @PathVariable("post_id") int postId,
//                                        @RequestBody PostRequest postRequest) {
//        User user = userRepository.findByUserLoginId(userDetails.getUsername())
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "사용자 인증 실패"));
//
//        Post post = postService.findPostById(postId)
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "해당 게시글을 찾을 수 없습니다."));
//
//        if (post.getUserId() != user.getUserId()) {
//            return ResponseUtil.buildErrorResponse(HttpStatus.FORBIDDEN, "Forbidden", "게시글 수정 권한이 없습니다.");
//        }
//
//        Post updatedPost = postService.updatePost(postId, postRequest.getPostName(), postRequest.getPostContent(), postRequest.getCategoryCode(), postRequest.getCategoryNumber());
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, Map.of("message", "게시글이 수정되었습니다.", "post_id", updatedPost.getPostId()));
//    }
//
//    // 게시글 상세 조회
//    @GetMapping("/{post_id}")
//    public ResponseEntity<?> getPostDetails(@PathVariable("post_id") int postId, @AuthenticationPrincipal UserDetails userDetails) {
//        User authenticatedUser = userRepository.findByUserLoginId(userDetails.getUsername())
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "인증되지 않은 사용자입니다."));
//
//        Post post = postService.findPostById(postId)
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "해당 게시글을 찾을 수 없습니다."));
//
//        CategoryDetail categoryDetail = categoryService.getCategoryDetails(post.getCategoryCode())
//                .stream()
//                .filter(detail -> detail.getNumber() == post.getCategoryNumber())
//                .findFirst()
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "카테고리 정보를 찾을 수 없습니다."));
//
//        Map<String, Object> response = new HashMap<>();
//        response.put("status", HttpStatus.OK.value());
//        response.put("name", "200 OK");
//        response.put("message", "게시글 정보");
//        response.put("post_id", post.getPostId());
//        response.put("post_name", post.getPostName());
//        response.put("post_content", post.getPostContent());
//        response.put("user_nickname", authenticatedUser.getUserNickname()); // 인증된 사용자 정보에서 닉네임 추출
//        response.put("created_at", post.getCreatedAt());
//        response.put("category_name", categoryDetail.getName());
//
//        return ResponseEntity.ok(response);
//    }
//
//    // 내가 쓴 게시글 조회
//    @GetMapping("/my")
//    public ResponseEntity<?> getMyPosts(@AuthenticationPrincipal UserDetails userDetails,
//                                        @RequestParam("category_code") String categoryCode,
//                                        @RequestParam("category_number") Integer categoryNumber) {
//        // 사용자 정보 조회
//        User user = userRepository.findByUserLoginId(userDetails.getUsername())
//                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "인증 실패"));
//
//        // 사용자가 작성한 게시글 중 특정 카테고리에 해당하는 게시글 조회
//        List<Post> posts = postService.findPostsByUserIdAndCategory(user.getUserId(), categoryCode, categoryNumber);
//
//        // 조회된 게시글을 기반으로 응답 생성
//        List<Map<String, Object>> responseBody = posts.stream().map(post -> {
//            Map<String, Object> postInfo = new HashMap<>();
//            postInfo.put("post_id", post.getPostId());
//            postInfo.put("post_name", post.getPostName());
//            postInfo.put("post_content", post.getPostContent());
//            postInfo.put("user_nickname", user.getUserNickname());
//            postInfo.put("created_at", post.getCreatedAt());
//
//            // 카테고리 이름 조회
//            String categoryName = categoryService.getCategoryDetails(categoryCode).stream()
//                    .filter(detail -> detail.getNumber() == categoryNumber)
//                    .findFirst()
//                    .map(CategoryDetail::getName)
//                    .orElse("Unknown Category");
//
//            postInfo.put("category_name", categoryName);
//            return postInfo;
//        }).collect(Collectors.toList());
//
//        return ResponseEntity.ok().body(Map.of("status", 200, "message", "조회 결과", "posts", responseBody));
//    }
//
//    // 카테고리 조회
//    @GetMapping("/categories")
//    public ResponseEntity<?> getCategories() {
//        String categoryCode = "POS";
//        List<CategoryDetail> categories = categoryService.getCategoryDetails(categoryCode);
//        List<Map<String, Object>> categoryList = categories.stream().map(category -> {
//            Map<String, Object> categoryMap = new HashMap<>();
//            categoryMap.put("code", String.valueOf(category.getNumber()));
//            categoryMap.put("name", category.getName());
//            return categoryMap;
//        }).collect(Collectors.toList());
//
//        Map<String, Object> data = new HashMap<>();
//        data.put("tag", categoryCode);
//        data.put("categoryList", categoryList);
//
//        Map<String, Object> response = new HashMap<>();
//        response.put("status", HttpStatus.OK.value());
//        response.put("name", "200 OK");
//        response.put("message", "조회 결과");
//        response.put("data", Collections.singletonList(data));
//
//        return new ResponseEntity<>(response, HttpStatus.OK);
//    }
//}