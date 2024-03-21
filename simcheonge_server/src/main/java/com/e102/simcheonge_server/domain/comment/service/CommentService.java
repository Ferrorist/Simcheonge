package com.e102.simcheonge_server.domain.comment.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.comment.dto.request.CommentCreateRequest;
import com.e102.simcheonge_server.domain.comment.dto.request.CommentReadRequest;
import com.e102.simcheonge_server.domain.comment.dto.response.CommentResponse;
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
import org.springframework.web.bind.annotation.PathVariable;

import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@AllArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepostory;
    private final PostRepository postRepository;
    private final PolicyRepository policyRepository;

    public void addComment(CommentCreateRequest commentRequest, final int userId) {
        if (commentRequest.getContent().isEmpty()) {
            throw new DataNotFoundException("해당 내용이 존재하지 않습니다.");
        }

        User user = userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));

        if (commentRequest.getCommentType().equals("POS")) {
            Post post = postRepository.findByPostId(commentRequest.getReferencedId())
                    .orElseThrow(() -> new DataNotFoundException("해당 게시물이 존재하지 않습니다."));
        } else if (commentRequest.getCommentType().equals("POL")) {
            Policy policy = policyRepository.findByPolicyId(commentRequest.getReferencedId())
                    .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        }

        Comment comment = Comment.builder()
                .user(userId)
                .referencedId(commentRequest.getReferencedId())
                .commentType(commentRequest.getCommentType())
                .commentContent(commentRequest.getContent())
                .build();
        commentRepository.save(comment);
    }

    public List<CommentResponse> getBoardComments(final String commentType, final int referencedId, final int userId) {
        User user = userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        if (commentType.equals("POS")) {
            Post post = postRepository.findByPostId(referencedId)
                    .orElseThrow(() -> new DataNotFoundException("해당 게시물이 존재하지 않습니다."));
        } else if (commentType.equals("POL")) {
            Policy policy = policyRepository.findByPolicyId(referencedId)
                    .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        }

        List<Comment> commentList = commentRepository.findByCommentTypeAndReferencedId(commentType, referencedId);
        List<CommentResponse> responses = new ArrayList<>();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        commentList.forEach(comment -> {
            User commenter = userRepostory.findByUserId(comment.getUser())
                    .orElseThrow(() -> new DataNotFoundException("해당 댓글 작성자가 존재하지 않습니다."));
            String nickname = commenter.getUserNickname();


            CommentResponse commentResponse = CommentResponse.builder()
                    .commentId(comment.getCommentId())
                    .nickname(nickname)
                    .content(comment.getCommentContent())
                    .createAt(formatter.format(comment.getCreatedAt()).toString())
                    .isMyComment(commenter.getUserId() == userId) //삭제된 회원이거나 요청 회원이 아닌 경우
                    .build();
            responses.add(commentResponse);
        });
        return responses;
    }

}
