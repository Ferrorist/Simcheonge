package com.e102.simcheonge_server.domain.comment.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.comment.dto.CommentRequest;
import com.e102.simcheonge_server.domain.comment.entity.Comment;
import com.e102.simcheonge_server.domain.comment.repository.CommentRepository;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.repository.PostRepository;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@AllArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepostory;
    private final PostRepository postRepository;
    private final PolicyRepository policyRepository;

    public void addComment(CommentRequest commentRequest, final int userId){
        if(commentRequest.getContent().isEmpty()){
            throw new DataNotFoundException("해당 내용이 존재하지 않습니다.");
        }

        User user=userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));

        if(commentRequest.getCommentType().equals("POS")){
            Post post=postRepository.findByPostId(commentRequest.getReferencedId())
                    .orElseThrow(()->new DataNotFoundException("해당 게시물이 존재하지 않습니다."));
        }
        else if(commentRequest.getCommentType().equals("POL")){
            Policy policy=policyRepository.findByPolicyId(commentRequest.getReferencedId())
                    .orElseThrow(()->new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        }

        Comment comment= Comment.builder()
                .user(userId)
                .referenced(commentRequest.getReferencedId())
                .commentType(commentRequest.getCommentType())
                .commentContent(commentRequest.getContent())
                .build();
        commentRepository.save(comment);
    }

//    public CommentResponse getComment(final int postId){
//        List<Comment> commentList=commentRepository.findByPostId(postId);
//        return
//    }
}
