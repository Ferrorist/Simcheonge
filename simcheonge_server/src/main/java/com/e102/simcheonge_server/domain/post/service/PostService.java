package com.e102.simcheonge_server.domain.post.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.repository.CategoryDetailRepository;
import com.e102.simcheonge_server.domain.post.dto.request.PostRequest;
import com.e102.simcheonge_server.domain.post.dto.response.PostDetailResponse;
import com.e102.simcheonge_server.domain.post.dto.response.PostResponse;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.repository.PostRepository;
import com.e102.simcheonge_server.domain.post_category.entity.PostCategory;
import com.e102.simcheonge_server.domain.post_category.repository.PostCategoryRepository;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
@Slf4j
@AllArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final PostCategoryRepository postCategoryRepository;
    private final CategoryDetailRepository categoryDetailRepository;

    // 게시글 등록
    @Transactional
    public Post createPost(PostRequest postRequest, String categoryCode, Integer categoryNumber, int userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));

        Post post = Post.builder()
                .userId(user.getUserId())
                .postName(postRequest.getPostName())
                .postContent(postRequest.getPostContent())
                .build();

        Post savedPost = postRepository.save(post);

        PostCategory postCategory = new PostCategory(categoryCode, categoryNumber, savedPost.getPostId());

        postCategoryRepository.save(postCategory);

        return savedPost;
    }

    // 게시글 조회
    public List<PostResponse> findPostsByCategoryCodeAndNumberWithKeyword(String categoryCode, Integer categoryNumber, String keyword) {
        List<Post> posts;

        // 키워드 검색 조건 처리
        if (keyword != null && keyword.trim().isEmpty()) {
            keyword = null; // 키워드가 공백인 경우 null로 처리하여 전체 조회
        }

        // 카테고리 넘버가 1인 경우 모든 게시글 조회
        if (categoryNumber == 1) {
            // 카테고리 코드나 넘버에 상관없이 모든 게시글을 검색 조건에 맞추어 조회
            posts = postRepository.findAllByKeyword(keyword);
        } else {
            // 기존 로직을 유지하여 특정 카테고리에 대한 게시글 조회
            posts = postRepository.findByCategoryDetailsAndKeyword(categoryCode, categoryNumber, keyword);
        }

        return posts.stream().map(post -> {
            String userNickname = userRepository.findById(post.getUserId())
                    .orElseThrow(() -> new IllegalArgumentException("User not found"))
                    .getUserNickname();

            String categoryName = categoryDetailRepository.findByCodeAndNumber(categoryCode, categoryNumber)
                    .map(CategoryDetail::getName)
                    .orElse("기타");

            return new PostResponse(
                    post.getPostId(),
                    post.getPostName(),
                    post.getPostContent(),
                    userNickname,
                    post.getCreatedAt(),
                    categoryName
            );
        }).collect(Collectors.toList());
    }

    // 게시글 수정
    @Transactional
    public void updatePost(int postId, PostRequest postRequest, int userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new DataNotFoundException("해당 게시글을 찾을 수 없습니다."));

        if (post.getUserId() != userId) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "게시글을 수정할 권한이 없습니다.");
        }

        // 게시글 내용 업데이트
        post.setPostName(postRequest.getPostName());
        post.setPostContent(postRequest.getPostContent());
        postRepository.save(post);

        // 기존 게시글 카테고리 정보 삭제
        PostCategory oldPostCategory = postCategoryRepository.findByPostId(postId)
                .orElseThrow(() -> new DataNotFoundException("해당 게시글의 카테고리 정보를 찾을 수 없습니다."));
        postCategoryRepository.delete(oldPostCategory);

        // 새로운 게시글 카테고리 정보 생성 및 저장
        PostCategory newPostCategory = new PostCategory(postRequest.getCategoryCode(), postRequest.getCategoryNumber(), postId);
        postCategoryRepository.save(newPostCategory);
    }

    // 게시글 삭제
    @Transactional
    public void deletePost(int postId, int userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new DataNotFoundException("해당 게시글을 찾을 수 없습니다."));

        if (post.getUserId() != userId) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "게시글을 삭제할 권한이 없습니다.");
        }

        // post_category 테이블에서 해당 게시글의 카테고리 정보 삭제
        Optional<PostCategory> postCategory = postCategoryRepository.findByPostId(postId);
        postCategory.ifPresent(postCategoryRepository::delete);

        // post 테이블에서 해당 게시글 삭제
        postRepository.deleteById(postId);
    }

//    public ResponseEntity<String> get(String url){
//        RestTemplate restTemplate=new RestTemplate();
//        HttpHeaders headers=new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_JSON); //여기 json이어도 되나?
//
//        HttpEntity<HttpHeaders> entity=new HttpEntity<>(headers);
//
//        ResponseEntity<String> response=restTemplate.exchange(URI.create(url),
//                HttpMethod.GET,entity,String.class);
//
//        return response;
//    }

    // 게시글 상세 조회
    public PostDetailResponse findPostDetailById(int postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "게시글을 찾을 수 없습니다."));

        User user = userRepository.findById(post.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."));

        // 카테고리 이름 조회 로직 (가정)
        String categoryName = "카테고리 예시"; // 실제로는 카테고리 관련 정보를 조회해야 합니다.

        return new PostDetailResponse(
                post.getPostId(),
                post.getPostName(),
                post.getPostContent(),
                user.getUserNickname(),
                post.getCreatedAt(),
                categoryName
        );
    }


}
