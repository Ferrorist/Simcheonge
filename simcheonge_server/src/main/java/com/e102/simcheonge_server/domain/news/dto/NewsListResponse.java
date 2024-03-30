package com.e102.simcheonge_server.domain.news.dto;

import lombok.*;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class NewsListResponse {
    private String lastBuildDate;
    private int total;
    private int start;
    private int display;
    private List<NewsItem> items;
}


