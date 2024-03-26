package com.e102.simcheonge_server.domain.post.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.repository.CategoryDetailRepository;
import com.e102.simcheonge_server.domain.post.dto.request.PostRequest;
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
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

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
                    .orElseThrow(() -> new IllegalArgumentException("CategoryDetail not found"))
                    .getName();

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








    // 게시글 삭제
    @Transactional
    public void deletePost(int postId, int userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new DataNotFoundException("해당 게시글을 찾을 수 없습니다."));

        if (post.getUserId() != userId) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "게시글을 삭제할 권한이 없습니다.");
        }

        postRepository.deleteById(postId);
    }

}
