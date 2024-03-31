package com.e102.simcheonge_server.domain.news.service;

import com.e102.simcheonge_server.domain.news.dto.NewsDetailResponse;
import java.net.http.HttpRequest.BodyPublishers;
import com.e102.simcheonge_server.domain.news.dto.NewsItem;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import java.net.http.HttpResponse.BodyHandlers;
import java.io.IOException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


@Service
public class NewsCrawlerService {
    @Value("${naver.crawler.url}")
    private String baseUrl;
    @Value("${openai.secret-key}")
    private String apiKey;

    public List<NewsItem> getNewsList() {
        List<NewsItem> newsItems = new ArrayList<>();
        List<Integer> sids = Arrays.asList(100, 101, 102, 105);

        sids.forEach(sid -> {
            String fullUrl = baseUrl + sid;
            int count = 0;
            try {
                Document doc = Jsoup.connect(fullUrl).get();
//                PrintWriter out1 = new PrintWriter(new OutputStreamWriter(new FileOutputStream("result1.html"), "UTF-8"));
//                out1.println(doc.toString()); // doc의 HTML 내용을 파일에 쓴다.

                Elements headlineNews = doc.select(".sa_list .sa_item._SECTION_HEADLINE"); //headline에 있는 기사들 추출
//                PrintWriter out2 = new PrintWriter(new OutputStreamWriter(new FileOutputStream("result2.html"), "UTF-8"));
//                out2.println(headlineNews.toString()); // doc의 HTML 내용을 파일에 쓴다.

                for (Element item : headlineNews) {
                    if (count >= 5) break;
                    String title = item.select(".sa_text > a > strong").text();
                    String description = item.select(".sa_text_lede").text();
                    String publisher = item.select(".sa_text_press").text();
                    String headlinesLinks = item.select(".sa_text > a").attr("href");
                    NewsItem newsItem = new NewsItem(title, description, publisher, headlinesLinks);
                    count++;
                    newsItems.add(newsItem);

                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        return newsItems;
    }


    public NewsDetailResponse getNewsDetail(String newsLink) {
            NewsDetailResponse newsDetailResponse = new NewsDetailResponse();

            try {
                Document newsDoc = Jsoup.connect(newsLink).get();
                String title = newsDoc.select("#title_area > span").text();

                String originalContent = newsDoc.select("#dic_area").text();
                String time = newsDoc.select("div.media_end_head_info_datestamp > div > span").text();
                String reporter = newsDoc.select("div.media_end_head_journalist > a > em").text();

                newsDetailResponse.setTitle(title);
                newsDetailResponse.setOriginalContent(originalContent);
                newsDetailResponse.setTime(time);
                newsDetailResponse.setReporter(reporter);

                String summarizedContent = summarizeTextWithChatGPT(originalContent);
                newsDetailResponse.setSummarizedContent(summarizedContent);

            } catch (IOException e) {
                e.printStackTrace();
            }
        return newsDetailResponse;
    }


    public String summarizeTextWithChatGPT(String originalText) {
        String apiURL = "https://api.openai.com/v1/chat/completions";

        // JSON 문자열 직접 생성
        String jsonBody = "{"
                + "\"model\": \"gpt-3.5-turbo\","
                + "\"messages\": ["
                + "{ \"role\": \"system\", \"content\": \"You are a helpful assistant.\" },"
                + "{ \"role\": \"user\", \"content\": \"다음 내용을 간략하게 요약해줘. 답변은 한글로 해줘:\\n" + originalText.replaceAll("\"", "\\\\\"") + "\" }"
                + "]"
                + "}";

        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiURL))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + this.apiKey)
                    .POST(BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
            String responseBody = response.body();
            // JSON 문자열 파싱

            ObjectMapper objectMapper = new ObjectMapper();

            JsonNode rootNode = objectMapper.readTree(responseBody);
            JsonNode choicesNode = rootNode.path("choices");
            if (choicesNode.isArray() && choicesNode.size() > 0) {
                JsonNode firstChoice = choicesNode.get(0);
                JsonNode messageNode = firstChoice.path("message");
                String content = messageNode.path("content").asText();

                System.out.println(content); // 생성된 텍스트 응답 출력
                return content; // 생성된 텍스트 응답 반환
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    return null;
    }
}

