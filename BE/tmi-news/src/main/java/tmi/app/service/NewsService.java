package tmi.app.service;

import tmi.app.dto.NewsRegisterRequest;
import tmi.app.entity.News;
import tmi.app.repository.NewsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class NewsService {

        private final NewsRepository newsRepository;

        public void registerNews(NewsRegisterRequest request) {
                // news_time을 LocalDateTime으로 파싱
                LocalDateTime parsedNewsTime = parseDateTime(request.getNewsTime());

                News news = News.builder()
                                .title(request.getTitle())
                                .content(request.getContent())
                                .category(request.getCategory())
                                .newsTime(parsedNewsTime)
                                .createdAt(LocalDateTime.now())
                                .build();

                newsRepository.save(news);
        }

        private LocalDateTime parseDateTime(String dateStr) {
                // "1995-09-02" 같은 형태라면 LocalDate로 파싱
                if (dateStr == null || dateStr.isEmpty()) {
                        return LocalDateTime.now();
                }
                try {
                        LocalDate d = LocalDate.parse(dateStr);
                        return d.atStartOfDay();
                } catch (Exception e) {
                        return LocalDateTime.now();
                }
        }
}