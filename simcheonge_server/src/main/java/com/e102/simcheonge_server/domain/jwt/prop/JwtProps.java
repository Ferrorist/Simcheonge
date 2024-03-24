package com.e102.simcheonge_server.domain.jwt.prop;


import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import lombok.Data;

// 해당 클래스는 Spring Boot의 `@ConfigurationProperties`
// 어노테이션을 사용하여, application.properties(속성 설정 파일) 로부터
// JWT 관련 프로퍼티를 관리하는 프로퍼티 클래스입니다.
@Data
@Component
@ConfigurationProperties("com.e102.simcheonge_server") // 괄호 내부 application-secret.properties의 Secretkey 앞에 작성된 경로 작성
public class JwtProps {

    // com.e102.simcheonge_server.secretKey로 지정된 프로퍼티 값을 주입받는 필드
    // com.e102.simcheonge_server.secret-key ➡ secretKey : {인코딩된 시크릿 키}
    private String secretKey;

}