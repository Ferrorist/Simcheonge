package com.e102.simcheonge_server.domain.policy.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.category.dto.response.CategoryResponse;
import com.e102.simcheonge_server.domain.category.dto.response.PolicyCategoryResponse;
import com.e102.simcheonge_server.domain.category.entity.Category;
import com.e102.simcheonge_server.domain.category.repository.CategoryRepository;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.repository.CategoryDetailRepository;
import com.e102.simcheonge_server.domain.policy.dto.response.PolicyThumbnailResponse;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@AllArgsConstructor
@Slf4j
public class PolicyService {
    private final PolicyRepository policyRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final CategoryDetailRepository categoryDetailRepository;

//    public PolicyThumbnailResponse getPolicy(int policyId, int userId) {
//        User user = userRepository.findById(userId)
//                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
//        Policy policy=policyRepository.findByPolicyId(policyId)
//                .orElseThrow(()->new DataNotFoundException("해당 정책이 존재하지 않습니다."));
//        String title=policy.getName();
//        PolicyThumbnailResponse thumbnailResponse=PolicyThumbnailResponse.builder()
//                .title(title)
//                .build();
//        return thumbnailResponse;
//    }

    public List<PolicyCategoryResponse> getCategories() {
        List<Category> categoryList = categoryRepository.findAllByCodeNot("POS");
        List<PolicyCategoryResponse> categoryResponses=new ArrayList<>();
        //카테고리
        List<CategoryResponse> categoryResponse1=new ArrayList<>();
        categoryList.forEach(category -> {
            CategoryResponse categoryResponse= CategoryResponse.builder()
                    .code(category.getCode())
                    .name(category.getName())
                    .build();
            categoryResponse1.add(categoryResponse);
        });
        PolicyCategoryResponse policyCategoryResponse=PolicyCategoryResponse.builder()
                .tag("menu")
                .categoryList(categoryResponse1)
                .build();
        categoryResponses.add(policyCategoryResponse);

        for(Category category:categoryList){
            //세부 카테고리
            List<CategoryResponse> categoryResponse2=new ArrayList<>();
            List<CategoryDetail> detailList = categoryDetailRepository.findAllByCode(category.getCode());
            detailList.forEach(detail->{
                CategoryResponse categoryResponse= CategoryResponse.builder()
                        .code(Integer.toString(detail.getNumber()))
                        .name(detail.getName())
                        .build();
                categoryResponse2.add(categoryResponse);
            });
            PolicyCategoryResponse policyCategoryDetailResponse=PolicyCategoryResponse.builder()
                    .tag(category.getCode())
                    .categoryList(categoryResponse2)
                    .build();
            categoryResponses.add(policyCategoryDetailResponse);
        }
        return categoryResponses;
    }
}
