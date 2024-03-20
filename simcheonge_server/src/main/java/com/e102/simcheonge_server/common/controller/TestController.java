package com.e102.simcheonge_server.common.controller;

import com.e102.simcheonge_server.common.TestEntity;
import com.e102.simcheonge_server.common.TestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
public class TestController {

    private final TestRepository testRepository;

    @Autowired
    public TestController(TestRepository testRepository) {
        this.testRepository = testRepository;
    }

    @GetMapping("/test")
    public String testDeployment() {
        return "Deployment is successful!";
    }

    @PostMapping("/test")
    public TestEntity createTestEntity(@RequestBody TestEntity testEntity) {
        return testRepository.save(testEntity);
    }

}