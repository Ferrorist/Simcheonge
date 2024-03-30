package com.e102.simcheonge_server.domain.bookmark.service;

import com.e102.simcheonge_server.domain.bookmark.dto.request.BookmarkCreateRequest;
import com.e102.simcheonge_server.domain.bookmark.dto.response.BookmarkResponse;
import com.e102.simcheonge_server.domain.bookmark.entity.Bookmark;
import com.e102.simcheonge_server.domain.bookmark.repository.BookmarkRepository;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.post.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BookmarkService {
    private final BookmarkRepository bookmarkRepository;
    private final PolicyRepository policyRepository;
    private final PostRepository postRepository;

    @Autowired
    public BookmarkService(BookmarkRepository bookmarkRepository, PolicyRepository policyRepository, PostRepository postRepository) {
        this.bookmarkRepository = bookmarkRepository;
        this.policyRepository = policyRepository;
        this.postRepository = postRepository;
    }

    // 북마크 등록
    public BookmarkResponse createBookmark(BookmarkCreateRequest request, int userId) {
        // 요청 유효성 검증 로직
        if (("POL".equals(request.getBookmarkType()) && request.getPolicyId() == null) ||
                ("POS".equals(request.getBookmarkType()) && request.getPostId() == null)) {
            throw new IllegalArgumentException("Invalid request: mismatch between bookmark type and provided ID");
        }

        // 실제 데이터 존재 여부 확인
        if ("POL".equals(request.getBookmarkType())) {
            if (request.getPolicyId() == null || !policyRepository.existsById(request.getPolicyId())) {
                throw new IllegalArgumentException("Invalid policy ID or policy does not exist.");
            }
        } else if ("POS".equals(request.getBookmarkType())) {
            if (request.getPostId() == null || !postRepository.existsById(request.getPostId())) {
                throw new IllegalArgumentException("Invalid post ID or post does not exist.");
            }
        } else {
            throw new IllegalArgumentException("Invalid bookmark type.");
        }

        // 요청받은 policyId 또는 postId를 referencedId에 저장
        int referencedId = 0;
        if ("POL".equals(request.getBookmarkType()) && request.getPolicyId() != null) {
            referencedId = request.getPolicyId();
        } else if ("POS".equals(request.getBookmarkType()) && request.getPostId() != null) {
            referencedId = request.getPostId();
        }

        // Bookmark 엔티티 생성 및 저장
        Bookmark bookmark = Bookmark.builder()
                .userId(userId)
                .referencedId(referencedId)
                .bookmarkType(request.getBookmarkType())
                .build();
        Bookmark savedBookmark = bookmarkRepository.save(bookmark);

        // 응답 반환
        return new BookmarkResponse(
                savedBookmark.getBookmarkId(),
                savedBookmark.getUserId(),
                savedBookmark.getReferencedId(),
                savedBookmark.getBookmarkType());
    }
}
