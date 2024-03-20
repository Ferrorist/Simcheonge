package com.e102.simcheonge_server.domain.post_category.entity;

import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetailId;
//import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "post_category")
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@IdClass(PostCategoryId.class)
public class PostCategory {
    @Id
    @Column(name = "category_code", nullable = false)
    private String categoryCode;

    @Id @Column(name = "category_number", nullable = false)
    private int categoryNumber;

    @Id
    @Column(name = "post_id", nullable = false)
    private int postId;
}
