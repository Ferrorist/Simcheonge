package com.e102.simcheonge_server.domain.policy.dto.request;

import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;

@Data @Builder
public class PolicySearchRequest {
    String keyword;
    ArrayList<CategoryDetailSearchRequest> list;
}
