package com.e102.simcheonge_server.common.config;

import com.e102.simcheonge_server.domain.youthplcy.service.YouthPlcyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class SchedulerConfiguration {
    private final YouthPlcyService youthPlcyService;

    @Scheduled(cron="0 3 4 ? * *")
    public void run(){
        youthPlcyService.insertUnprocessedPolicyData();
    }
}
