package com.e102.simcheonge_server.domain.category.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Table(name = "category")
public class Category {
    @Id @Column(name = "category_code", length = 21)
    @NotNull
    private String code;

    @Column(name = "category_name", length = 100, nullable = false)
    private String name;
}
