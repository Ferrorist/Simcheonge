package com.e102.simcheonge_server.domain.post.repository;

import com.e102.simcheonge_server.domain.post.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PostRepository extends JpaRepository<Post, Integer> {
    // 특정 게시글 상세 조회
    Optional<Post> findByPostId(int postId);

    // 특정 키워드가 포함된 게시글 검색 (제목 또는 내용)
    @Query("SELECT p FROM Post p WHERE p.postName LIKE %:keyword% OR p.postContent LIKE %:keyword%")
    List<Post> findByKeyword(@Param("keyword") String keyword);

    // 특정 사용자가 작성한 게시글 조회
    List<Post> findByUserId(int userId);

    @Query("SELECT p FROM Post p WHERE (:keyword IS NULL OR (p.postName LIKE %:keyword% OR p.postContent LIKE %:keyword%)) AND (:categoryCode IS NULL OR p.categoryDetail.code = :categoryCode) AND (:categoryNumber IS NULL OR p.categoryDetail.number = :categoryNumber)")
    List<Post> findByKeywordAndCategoryCodeAndCategoryNumber(@Param("keyword") String keyword, @Param("categoryCode") String categoryCode, @Param("categoryNumber") Integer categoryNumber);

    // 카테고리 코드와 번호로 게시글 검색
    @Query("SELECT p FROM Post p WHERE p.categoryDetail.code = :categoryCode AND p.categoryDetail.number = :categoryNumber")
    List<Post> findByCategoryCodeAndCategoryNumber(@Param("categoryCode") String categoryCode, @Param("categoryNumber") Integer categoryNumber);
}
