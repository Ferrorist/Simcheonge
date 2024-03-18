package com.e102.simcheonge_server.domain.post_category.entity;

import com.e102.simcheonge_server.domain.category.entity.Category;
import com.e102.simcheonge_server.domain.post.entity.Post;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Table(name = "post_category")
@IdClass(PostCategoryId.class)
public class PostCategory {
    @Id
    @Column(name = "category_code")
    private String categoryCode;

    @Id
    @Column(name = "post_id")
    private int postId;
}
