package com.e102.simcheonge_server.domain.policy.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.policy.service.PolicyService;
import com.e102.simcheonge_server.domain.user.dto.SessionUser;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@Slf4j
@RequestMapping("/policy")
public class PolicyController {
    private final PolicyService policyService;

//    @GetMapping("/{policyId}")
//    public ResponseEntity<?> getPolicy(@PathVariable("policyId") int policyId, @SessionAttribute(name = "user", required = false)
//    SessionUser loginUser) {
//        policyService.getPolicy(policyId, loginUser.getUserId());
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "댓글 삭제에 성공했습니다.");
//    }

    @GetMapping("/categories")
    public ResponseEntity<?> getCategories(){
        return ResponseUtil.buildBasicResponse(HttpStatus.OK,policyService.getCategories());
    }
}
