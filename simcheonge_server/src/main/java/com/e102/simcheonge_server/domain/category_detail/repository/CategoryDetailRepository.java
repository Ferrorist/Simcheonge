package com.e102.simcheonge_server.domain.category_detail.repository;

import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetailId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryDetailRepository extends JpaRepository<CategoryDetail, CategoryDetailId> {

    List<CategoryDetail> findAllByCode(String code);

    Integer countByCode(String code);
}
