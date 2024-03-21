package com.e102.simcheonge_server.domain.post.controller;

import com.e102.simcheonge_server.domain.post.dto.PostRequest;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.service.PostService;
<<<<<<< Updated upstream
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
=======
import com.e102.simcheonge_server.common.util.ResponseUtil;
>>>>>>> Stashed changes
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

<<<<<<< Updated upstream
import java.util.List;
import java.util.Optional;
=======
import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;
>>>>>>> Stashed changes

@RestController
@RequestMapping("/posts")
public class PostController {
<<<<<<< Updated upstream
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
=======
//    @Autowired
//    private PostService postService;
//
//    // 게시글 조회 (카테고리별, 전체 포함)
//    @GetMapping
//    public ResponseEntity<?> getPostsByCategory(@RequestParam(value = "category_code", required = false) String categoryCode,
//                                                @RequestParam(value = "keyword", required = false) String keyword) {
//        List<Post> posts;
//        if (keyword != null) {
//            posts = postService.searchPosts(keyword);
//        } else {
//            posts = postService.findPostsByCategory(categoryCode == null ? "전체" : categoryCode);
//        }
//        List<PostResponse> response = posts.stream()
//                .map(post -> new PostResponse(post.getPostId(), post.getPostName(), post.getPostContent(),
//                        post.getUserNickname(), post.getCreatedAt()))
//                .collect(Collectors.toList());
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, response);
//    }
//
//    // 게시글 등록
//    @PostMapping
//    public ResponseEntity<?> createPost(@RequestBody PostRequest postRequest, Principal principal) {
//        // 여기서 principal.getName()으로 사용자 인증 정보를 가져옵니다. 실제 구현은 서비스 계층에서 진행
//        Post post = postService.createPost(
//                new Post(postRequest.getPostName(), postRequest.getPostContent(), principal.getName()),
//                postRequest.getCategoryCode());
//        PostResponse response = new PostResponse(post.getPostId(), post.getPostName(), post.getPostContent(),
//                post.getUserNickname(), post.getCreatedAt());
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, response);
//    }
//
//    // 게시글 삭제
//    @DeleteMapping("/{post_id}")
//    public ResponseEntity<?> deletePost(@PathVariable("post_id") int postId, Principal principal) {
//        // 여기서도 principal.getName()을 사용하여 사용자 인증 정보 확인
//        postService.deletePost(postId);
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "게시글이 삭제되었습니다.");
//    }
//
//    // 게시글 수정
//    @PatchMapping("/{post_id}")
//    public ResponseEntity<?> updatePost(@PathVariable("post_id") int postId, @RequestBody PostRequest postRequest,
//                                        Principal principal) {
//        Post post = postService.updatePost(postId, postRequest.getPostName(), postRequest.getPostContent());
//        if (post == null) {
//            return ResponseUtil.buildErrorResponse(HttpStatus.NOT_FOUND, "Post Not Found", "해당 게시글을 찾을 수 없습니다.");
//        }
//        PostResponse response = new PostResponse(post.getPostId(), post.getPostName(), post.getPostContent(),
//                post.getUserNickname(), post.getCreatedAt());
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, response);
//    }
//
//    // 게시글 상세 조회
//    @GetMapping("/{post_id}")
//    public ResponseEntity<?> getPostById(@PathVariable("post_id") int postId) {
//        Post post = postService.findPostById(postId)
//                .orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));
//        PostResponse response = new PostResponse(post.getPostId(), post.getPostName(), post.getPostContent(),
//                post.getUserNickname(), post.getCreatedAt());
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, response);
//    }
>>>>>>> Stashed changes
}
