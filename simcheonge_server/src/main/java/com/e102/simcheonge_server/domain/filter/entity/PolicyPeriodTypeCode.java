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
@Table(name = "policy_period_type_code_table")
public class PolicyPeriodTypeCode {
    @Id
    @Column(name = "policy_period_type_code", length = 6)
    @NotNull
    private String policyPeriodTypeCode;
}
