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
@Table(name = "policy_education_requirements_table")
public class PolicyEducationRequirements {
    @Id
    @Column(name = "policy_education_requirements", length = 20)
    @NotNull
    private String policyEducationRequirements;
}
