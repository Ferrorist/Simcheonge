package com.e102.simcheonge_server.domain.policy.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicySearchRequest;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicyUpdateRequest;
import com.e102.simcheonge_server.domain.policy.service.PolicyService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@Slf4j
@RequestMapping("/policy")
public class PolicyController {
    private final PolicyService policyService;
    private final int DEFAULT_SIZE = 15;

    @GetMapping("/{policyId}")
    public ResponseEntity<?> getPolicy(@PathVariable("policyId") int policyId) {

        return ResponseUtil.buildBasicResponse(HttpStatus.OK, policyService.getPolicy(policyId));
    }

    @PatchMapping("/{policyId}")
    public ResponseEntity<?> updatePolicy(@PathVariable("policyId") int policyId,
                                          @RequestBody PolicyUpdateRequest policyUpdateRequest,
                                          @SessionAttribute(name = "user", required = false)
                                          SessionUser loginUser) {
        policyService.updatePolicy(policyId,policyUpdateRequest,loginUser.getUserId());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "정책 수정에 성공했습니다.");
    }

    @PostMapping("/search")
    public ResponseEntity<?> searchPolicies(@RequestBody PolicySearchRequest policySearchRequest,
                                            @PageableDefault(size = DEFAULT_SIZE, page = 0, sort = "createdAt", direction = Sort.Direction.DESC) final Pageable pageable) {


        return ResponseUtil.buildBasicResponse(HttpStatus.OK, policyService.searchPolicies(policySearchRequest,pageable));
    }

    @GetMapping("/categories")
    public ResponseEntity<?> getCategories(){
        return ResponseUtil.buildBasicResponse(HttpStatus.OK,policyService.getCategories());
    }

}
