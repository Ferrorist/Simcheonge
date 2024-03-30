package com.e102.simcheonge_server.domain.news.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.news.service.NewsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;


@RestController
@RequiredArgsConstructor
@RequestMapping("/news")
public class NewsController {
    private final NewsService newsService;

    // GET 방식의 어노테이션을 사용
    @GetMapping
    public ResponseEntity<?> NewsList(){
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, newsService.getNewsList());
    }
}