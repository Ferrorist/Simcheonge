package com.e102.simcheonge_server.domain.comment.service;

import com.e102.simcheonge_server.domain.comment.repository.CommentRepository;
import com.e102.simcheonge_server.domain.post.repository.PostRepository;
import com.e102.simcheonge_server.domain.user.repository.UserRepostory;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@AllArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepostory userRepostory;
    private final PostRepository postRepository;

//    public void addComment(CommentRequest commentRequest, final int userId){
//        User user=userRepostory.findById(userId).get();
//        Post post=postRepository.findById(commentRequest.getPostId()).get();
//
//        if(commentRequest.getCommentType().equals("POS")){
//            Post post=postRepository.findById(commentRequest.getPostId()).get();
//
//        }
//
//        Comment comment= Comment.builder()
//                .user(user)
//
//                .build();
//    }

//    public CommentResponse getComment(final int postId){
//        List<Comment> commentList=commentRepository.findByPostId(postId);
//        return
//    }
}
