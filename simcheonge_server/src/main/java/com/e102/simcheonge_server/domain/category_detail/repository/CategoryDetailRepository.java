package com.e102.simcheonge_server.domain.category_detail.repository;

import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetailId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryDetailRepository extends JpaRepository<CategoryDetail, CategoryDetailId> {
}
