package com.e102.simcheonge_server.domain.policy.entity;

import com.e102.simcheonge_server.domain.category.entity.Category;
import com.e102.simcheonge_server.domain.filter.entity.*;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Table(name = "policy")
public class Policy {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "policy_id")
    private int policyId;

    @Column(name = "policy_code", length = 16, nullable = false)
    private String code;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_area")
    @NotNull
    private Category area;

    @Column(name = "policy_name", nullable = false, columnDefinition = "TEXT")
    private String name;

    @Column(name = "policy_intro", columnDefinition = "TEXT")
    private String intro;

    @Column(name = "policy_support_content", columnDefinition = "TEXT")
    private String supportContent;

    @Column(name = "policy_support_scale", columnDefinition = "TEXT")
    private String supportScale;

    @Column(name = "policy_etc", columnDefinition = "TEXT")
    private String etc;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_field")
    @NotNull
    private Category field;

    @Column(name = "policy_business_period", columnDefinition = "TEXT")
    private String businessPeriod;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_period_type_code")
    @NotNull
    private Category periodTypeCode;

    @Column(name = "policy_start_date", columnDefinition = "DATE")
    private Date startDate;

    @Column(name = "policy_end_date", columnDefinition = "DATE")
    private Date endDate;

    @Column(name = "policy_age_info", length = 40)
    private String ageInfo;

    @Column(name = "policy_major_requirements", columnDefinition = "TEXT")
    private String majorRequirements;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_employment_status")
    @NotNull
    private Category employmentStatus;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_specialized_field")
    @NotNull
    private Category specializedField;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_education_requirements")
    @NotNull
    private Category educationRequirements;

    @Column(name = "policy_residence_income", columnDefinition = "TEXT")
    private String residenceIncome;

    @Column(name = "policy_additional_clues", columnDefinition = "TEXT")
    private String additionalClues;

    @Column(name = "policy_entry_limit", columnDefinition = "TEXT")
    private String entryLimit;

    @Column(name = "policy_application_procedure", columnDefinition = "TEXT")
    private String applicationProcedure;

    @Column(name = "policy_required_documents", columnDefinition = "TEXT")
    private String requiredDocuments;

    @Column(name = "policy_evaluation_content", columnDefinition = "TEXT")
    private String evaluationContent;

    @Column(name = "policy_site_address", length = 1000)
    private String siteAddress;

    @Column(name = "policy_main_organization", columnDefinition = "TEXT")
    private String mainOrganization;

    @Column(name = "policy_main_contact", columnDefinition = "TEXT")
    private String mainContact;

    @Column(name = "policy_operation_organization", columnDefinition = "TEXT")
    private String operationOrganization;

    @Column(name = "policy_operation_organization_contact", columnDefinition = "TEXT")
    private String operationOrganizationContact;

    @Column(name = "policy_is_processed", nullable = false)
    private boolean isProcessed = false;

    @Column(name = "policy_processed_at", columnDefinition = "DATETIME")
    private Date processedAt;

    @Column(name = "policy_created_at", columnDefinition = "DATETIME")
    private Date createdAt;

}
