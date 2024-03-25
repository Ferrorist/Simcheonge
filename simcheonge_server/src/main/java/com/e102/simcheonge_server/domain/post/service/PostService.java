package com.e102.simcheonge_server.domain.post.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

//    public List<Post> searchPostsByCategoryAndKeyword(String categoryCode, Integer categoryNumber, String keyword) {
//        // keyword가 주어졌을 때 해당 키워드를 포함하는 게시글 검색
//        return postRepository.findByCategoryCodeAndCategoryNumberAndKeyword(categoryCode, categoryNumber, keyword);
//    }
//
//    public List<Post> findPostsByCategory(String categoryCode, Integer categoryNumber) {
//        // 카테고리 코드와 카테고리 넘버에 따라 게시글 조회
//        return postRepository.findByCategoryCodeAndCategoryNumber(categoryCode, categoryNumber);
//    }
//
//    // 카테고리 코드에 따른 게시글 조회
//    @Transactional(readOnly = true)
//    public List<Post> findPostsByCategoryAndKeyword(String categoryCode, Integer categoryNumber, String keyword) {
//        // "POS" 카테고리 코드를 기본값으로 사용
//        categoryCode = Optional.ofNullable(categoryCode).orElse("POS");
//        // 카테고리와 키워드 기반 검색 로직
//        if (keyword != null && !keyword.isEmpty()) {
//            return postRepository.findByKeywordAndCategoryCodeAndCategoryNumber(keyword, categoryCode, categoryNumber);
//        } else if (categoryCode != null && categoryNumber != null) {
//            return postRepository.findByCategoryCodeAndCategoryNumber(categoryCode, categoryNumber);
//        } else {
//            return postRepository.findAll();
//        }
//    }

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

    // 게시글 삭제
//    @Transactional
//    public void deletePost(int postId) {
//        postRepository.deleteById(postId);
//    }
//
//    // 게시글 수정
//    @Transactional
//    public Post updatePost(int postId, String postName, String postContent, String categoryCode, Integer categoryNumber) {
//        Optional<Post> postOptional = postRepository.findByPostId(postId);
//        if (postOptional.isPresent()) {
//            Post post = postOptional.get();
//            post.setPostName(postName);
//            post.setPostContent(postContent);
//            return postRepository.save(post);
//        } else {
//            // 예외 처리 혹은 다른 로직 구현
//            return null;
//        }
//    }
//
//    // 게시글 상세 조회
//    public Optional<Post> findPostById(int postId) {
//        return postRepository.findByPostId(postId);
//    }
//
//    // 게시글 검색 (제목 또는 내용 기준)
//    public List<Post> searchPosts(String keyword) {
//        return postRepository.findByKeyword(keyword);
//    }
//
//    // 내가 쓴 게시글 조회
//    public List<Post> findPostsByUserId(int userId) {
//        return postRepository.findByUserId(userId);
//    }
//
//    // 사용자 ID와 카테고리 코드, 넘버에 따라 게시글을 조회하는 메서드
//    public List<Post> findPostsByUserIdAndCategory(int userId, String categoryCode, int categoryNumber) {
//        return postRepository.findByUserIdAndCategoryCodeAndCategoryNumber(userId, categoryCode, categoryNumber);
//    }
}
