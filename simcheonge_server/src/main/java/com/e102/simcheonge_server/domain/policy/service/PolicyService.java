package com.e102.simcheonge_server.domain.policy.service;

import com.e102.simcheonge_server.common.exception.AuthenticationException;
import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.category.dto.response.CategoryResponse;
import com.e102.simcheonge_server.domain.category.dto.response.PolicyCategoryResponse;
import com.e102.simcheonge_server.domain.category.entity.Category;
import com.e102.simcheonge_server.domain.category.repository.CategoryRepository;
import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.repository.CategoryDetailRepository;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicySearchRequest;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicyUpdateRequest;
import com.e102.simcheonge_server.domain.policy.dto.response.PolicyDetailResponse;
import com.e102.simcheonge_server.domain.policy.dto.response.PolicyThumbnailResponse;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyCustomRepository;
import com.e102.simcheonge_server.domain.policy.repository.PolicyNativeRepository;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@AllArgsConstructor
@Slf4j
public class PolicyService {
    private final PolicyRepository policyRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final CategoryDetailRepository categoryDetailRepository;
    private final PolicyNativeRepository policyNativeRepository;
    private final HashMap<String, Integer> categoryCheckMap = new HashMap<>();
    private final String[] checkCategories = {"ADM", "SPC", "EPM"};

    public PolicyDetailResponse getPolicy(int policyId) {
        Policy policy = policyRepository.findByPolicyId(policyId)
                .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));

        String policy_period_type_code = policy.getPeriodTypeCode();
        if (policy.getPeriodTypeCode().equals("002001")) policy_period_type_code = "상시";
        else if (policy.getPeriodTypeCode().equals("002005")) policy_period_type_code = "미정";
        else if (policy.getPeriodTypeCode().equals("002004")) policy_period_type_code = "특정 기간";

        PolicyDetailResponse thumbnailResponse = PolicyDetailResponse.builder()
                .policy_name(Optional.ofNullable(policy.getName()).orElse(""))
                .policy_intro(Optional.ofNullable(policy.getIntro()).orElse(""))
                .policy_support_scale(Optional.ofNullable(policy.getSupportScale()).orElse(""))
                .policy_period_type_code(policy_period_type_code)
                .policy_start_date(Optional.ofNullable(policy.getStartDate()).map(Object::toString).orElse(""))
                .policy_end_date(Optional.ofNullable(policy.getEndDate()).map(Object::toString).orElse(""))
                .policy_main_organization(Optional.ofNullable(policy.getMainOrganization()).orElse(""))
                .policy_operation_organization(Optional.ofNullable(policy.getOperationOrganization()).orElse(""))
                .policy_area(Optional.ofNullable(policy.getArea()).orElse(""))
                .policy_age_info(Optional.ofNullable(policy.getAgeInfo()).orElse(""))
                .policy_education_requirements(Optional.ofNullable(policy.getEducationRequirements()).orElse(""))
                .policy_major_requirements(Optional.ofNullable(policy.getMajorRequirements()).orElse(""))
                .policy_employment_status(Optional.ofNullable(policy.getEmploymentStatus()).orElse(""))
                .policy_site_address(Optional.ofNullable(policy.getSiteAddress()).orElse(""))
                .policy_support_content(Optional.ofNullable(policy.getSupportContent()).orElse(""))
                .policy_entry_limit(Optional.ofNullable(policy.getEntryLimit()).orElse(""))
                .policy_application_procedure(Optional.ofNullable(policy.getApplicationProcedure()).orElse(""))
                .policy_etc(Optional.ofNullable(policy.getEtc()).orElse(""))
                .build();
        return thumbnailResponse;
    }

    public List<PolicyCategoryResponse> getCategories() {
        List<Category> categoryList = categoryRepository.findAllByCodeNot("POS");
        List<PolicyCategoryResponse> categoryResponses = new ArrayList<>();
        //카테고리
        List<CategoryResponse> categoryResponse1 = new ArrayList<>();
        categoryList.forEach(category -> {
            CategoryResponse categoryResponse = CategoryResponse.builder()
                    .code(category.getCode())
                    .name(category.getName())
                    .build();
            categoryResponse1.add(categoryResponse);
        });
        PolicyCategoryResponse policyCategoryResponse = PolicyCategoryResponse.builder()
                .tag("menu")
                .categoryList(categoryResponse1)
                .build();
        categoryResponses.add(policyCategoryResponse);

        for (Category category : categoryList) {
            //세부 카테고리
            List<CategoryResponse> categoryResponse2 = new ArrayList<>();
            List<CategoryDetail> detailList = categoryDetailRepository.findAllByCode(category.getCode());
            detailList.forEach(detail -> {
                CategoryResponse categoryResponse = CategoryResponse.builder()
                        .code(Integer.toString(detail.getNumber()))
                        .name(detail.getName())
                        .build();
                categoryResponse2.add(categoryResponse);
            });
            PolicyCategoryResponse policyCategoryDetailResponse = PolicyCategoryResponse.builder()
                    .tag(category.getCode())
                    .categoryList(categoryResponse2)
                    .build();
            categoryResponses.add(policyCategoryDetailResponse);
        }
        return categoryResponses;
    }

    public void updatePolicy(int policyId, PolicyUpdateRequest policyUpdateRequest, int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        if (!"admin".equals(user.getUserLoginId())) {
            throw new AuthenticationException("관리자 권한이 필요합니다.");
        }
        Policy policy = policyRepository.findByPolicyId(policyId)
                .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        policy.updatePolicy(policyUpdateRequest);
        policyRepository.save(policy);
    }

    public PageImpl<PolicyThumbnailResponse> searchPolicies(PolicySearchRequest policySearchRequest, Pageable pageable) {

        validatePolicySearchRequest(policySearchRequest);

        PageImpl<Object[]> policyObjectList = policyNativeRepository.searchPolicy(policySearchRequest.getKeyword(), policySearchRequest.getList(), policySearchRequest.getStartDate(), policySearchRequest.getEndDate(), pageable);
        List<PolicyThumbnailResponse> responseList = new ArrayList<>();
        for (Object[] policyObject : policyObjectList) {
            Integer policyId = (Integer) policyObject[0];
            String policyName = (String) policyObject[3];

            PolicyThumbnailResponse thumbnailResponse = PolicyThumbnailResponse.builder()
                    .policyId(policyId)
                    .policy_name(policyName)
                    .build();
            responseList.add(thumbnailResponse);
        }
        return new PageImpl<>(responseList, pageable, policyObjectList.getTotalElements());
    }

    private void validatePolicySearchRequest(PolicySearchRequest policySearchRequest) {
        if(policySearchRequest.getKeyword()==null){
            throw new IllegalArgumentException("키워드는 null일 수 없습니다. keyword에 빈 값을 담아 요청해주세요.");
        }

        // {APC,3}일 경우 startDate, endDate null확인
        int APCCount = 1;
        boolean isAPC3exist = false;
        for (CategoryDetailSearchRequest category : policySearchRequest.getList()) {
            //{ADM,1}, {EPM,1}, {SPC, 1}가 있는지 확인
            if (Arrays.asList(checkCategories).contains(category.getCode()) && category.getNumber() == 1) {
                throw new IllegalArgumentException("해당 카테고리는 '제한 없음'을 선택할 수 없습니다.");
            }
            else if ("APC".equals(category.getCode())) {
                if (category.getNumber() == 3) {
                    if (policySearchRequest.getStartDate() == null || policySearchRequest.getEndDate() == null) {
                        throw new IllegalArgumentException("특정 기간의 startDate, endDate가 없습니다.");
                    }
                    isAPC3exist = true;
                }
                APCCount++;
            }
        }
        if (isAPC3exist && APCCount > 1) {
            throw new IllegalArgumentException("'특정 기간'은 '상시'나 '미정'과 함께 선택할 수 없습니다.");
        }
        log.info("체크5");
    }


}
