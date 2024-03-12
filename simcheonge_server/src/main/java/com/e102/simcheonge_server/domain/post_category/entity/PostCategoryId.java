package com.e102.simcheonge_server.domain.post_category.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostCategoryId implements Serializable {
    private int postId;
    private byte categoryId;
}
