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
@Table(name = "policy_field_table")
public class PolicyField {
    @Id @Column(name = "policy_field", length = 6)
    @NotNull
    private String policyField;

    @Column(name = "policy_field_name", length = 30, nullable = false)
    private String policyFieldName;
}
