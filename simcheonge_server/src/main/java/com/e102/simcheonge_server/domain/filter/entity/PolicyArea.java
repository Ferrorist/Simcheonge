package com.e102.simcheonge_server.domain.filter.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Table(name = "policy_area_table")
public class PolicyArea {
    @Id @Column(name = "policy_area", length = 16)
    @NotNull
    private String policyArea;

    @Column(name = "policy_area_name", length = 32, nullable = false)
    private String policyAreaName;
}
