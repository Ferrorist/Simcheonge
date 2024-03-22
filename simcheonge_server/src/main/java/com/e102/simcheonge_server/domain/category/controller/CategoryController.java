//package com.e102.simcheonge_server.domain.category.controller;
//
//import com.e102.simcheonge_server.common.util.ResponseUtil;
//import com.e102.simcheonge_server.domain.category.service.CategoryService;
//import lombok.AllArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//@RestController
//@AllArgsConstructor
//@Slf4j
//@RequestMapping("/category")
//public class CategoryController {
//    private final CategoryService categoryService;
//
//    @GetMapping
//    public ResponseEntity<?> getCategories(){
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK,categoryService.getCategories());
//    }
//}
