package com.e102.simcheonge_server.domain.bookmark.repository;

import com.e102.simcheonge_server.domain.bookmark.entity.Bookmark;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookmarkRepository extends JpaRepository<Bookmark, Integer> {
}
