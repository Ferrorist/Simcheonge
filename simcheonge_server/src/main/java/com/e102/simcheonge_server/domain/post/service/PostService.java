package com.e102.simcheonge_server.domain.post.service;

import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.repository.PostRepository;
import com.e102.simcheonge_server.domain.post_category.entity.PostCategory;
import com.e102.simcheonge_server.domain.post_category.repository.PostCategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
public class PostService {

    private final PostRepository postRepository;
    private final PostCategoryRepository postCategoryRepository;

    @Autowired
    public PostService(PostRepository postRepository, PostCategoryRepository postCategoryRepository) {
        this.postRepository = postRepository;
        this.postCategoryRepository = postCategoryRepository;
    }

    // 카테고리 코드에 따른 게시글 조회
    public List<Post> findPostsByCategoryAndKeyword(String categoryCode, Integer categoryNumber, String keyword) {
        // 카테고리와 키워드 기반 검색 로직
        if (keyword != null && !keyword.isEmpty()) {
            return postRepository.findByKeywordAndCategoryCodeAndCategoryNumber(keyword, categoryCode, categoryNumber);
        } else if (categoryCode != null && categoryNumber != null) {
            return postRepository.findByCategoryCodeAndCategoryNumber(categoryCode, categoryNumber);
        } else {
            return postRepository.findAll();
        }
    }

    // 게시글 등록
    @Transactional
    public Post createPost(Post post, String categoryCode, Integer categoryNumber) {
        Post savedPost = postRepository.save(post);
        PostCategory postCategory = new PostCategory(categoryCode, categoryNumber, savedPost.getPostId());
        postCategoryRepository.save(postCategory);
        return savedPost;
    }

    // 게시글 삭제
    @Transactional
    public void deletePost(int postId) {
        postRepository.deleteById(postId);
    }

    // 게시글 수정
    @Transactional
    public Post updatePost(int postId, String postName, String postContent) {
        Optional<Post> postOptional = postRepository.findByPostId(postId);
        if (postOptional.isPresent()) {
            Post post = postOptional.get();
            post.setPostName(postName);
            post.setPostContent(postContent);
            return postRepository.save(post);
        } else {
            // 예외 처리 혹은 다른 로직 구현
            return null;
        }
    }

    // 게시글 상세 조회
    public Optional<Post> findPostById(int postId) {
        return postRepository.findByPostId(postId);
    }

    // 게시글 검색 (제목 또는 내용 기준)
    public List<Post> searchPosts(String keyword) {
        return postRepository.findByKeyword(keyword);
    }

    // 내가 쓴 게시글 조회
    public List<Post> findPostsByUserId(int userId) {
        return postRepository.findByUserId(userId);
    }
}
