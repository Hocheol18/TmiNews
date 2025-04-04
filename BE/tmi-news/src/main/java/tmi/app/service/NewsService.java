package tmi.app.service;

import tmi.app.dto.NewsRegisterRequest;
import tmi.app.entity.News;
import tmi.app.repository.NewsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import tmi.app.entity.User;
import tmi.app.dto.NewsDetailDto;
import java.util.Collections;


@Service
@RequiredArgsConstructor
public class NewsService {

        private final NewsRepository newsRepository;

        public void registerNews(NewsRegisterRequest request, User user) {
                // news_time을 LocalDateTime으로 파싱
                LocalDateTime parsedNewsTime = parseDateTime(request.getNewsTime());

                News news = News.builder()
                        .user(user) // 반드시 user 할당
                        .title(request.getTitle())
                        .content(request.getContent())
                        .category(request.getCategory())
                        .newsTime(parsedNewsTime)
                        .createdAt(LocalDateTime.now())
                        .build();

                newsRepository.save(news);
        }

        public void deleteNews(Long newsId, User user) {
                // newsId로 News 엔티티 조회
                News news = newsRepository.findById(newsId)
                        .orElseThrow(() -> new RuntimeException("해당 뉴스가 존재하지 않습니다."));

                // 뉴스의 작성자와 현재 요청한 사용자가 같은지 확인 (권한 체크)
                if (!news.getUser().getUserId().equals(user.getUserId())) {
                        throw new RuntimeException("해당 뉴스를 삭제할 권한이 없습니다.");
                }

                // 뉴스 삭제
                newsRepository.delete(news);
        }

        public NewsDetailDto getNewsDetail(Long newsId, Long userId) {
                // 1) News 엔티티 조회
                News news = newsRepository.findById(newsId)
                        .orElseThrow(() -> new RuntimeException("해당 뉴스가 존재하지 않습니다."));

                // 2) 댓글, 좋아요가 아직 구현되지 않았다면, 일단 빈 값으로 세팅
                //    -> 댓글/좋아요 기능 구현 시 DB에서 조회한 값으로 채우면 됨

                // 예시 DTO를 만들어서 반환 (NewsDetailDto 등)
                return NewsDetailDto.builder()
                        .title(news.getTitle())
                        .content(news.getContent())
                        .createdAt(news.getCreatedAt())
                        .newsTime(news.getNewsTime())
                        .comments(Collections.emptyList())  // 댓글 기능 미구현 시 빈 리스트
                        .likes(0)                          // 좋아요 기능 미구현 시 0
                        .build();
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