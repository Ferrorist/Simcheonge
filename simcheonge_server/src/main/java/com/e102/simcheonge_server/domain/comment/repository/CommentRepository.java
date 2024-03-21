package com.e102.simcheonge_server.domain.comment.repository;

import com.e102.simcheonge_server.domain.comment.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Integer> {

    List<Comment> findByCommentTypeAndReferencedId(String commentType, int referencedId);

    List<Comment> findByUserAndAndCommentType(int userId,String commentType);

}
