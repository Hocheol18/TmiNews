package tmi.app.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {

    @Value("${ai.service.url}")
    private String aiServiceUrl;

    @Bean
    public WebClient webClient() {
        System.out.println("AI Service URL: " + aiServiceUrl); // 디버깅용 로그
        return WebClient.builder()
                .baseUrl(aiServiceUrl)
                .build();
    }
}
