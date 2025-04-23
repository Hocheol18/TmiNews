package tmi.app.service;

import tmi.app.dto.NewsRegisterRequest;
import tmi.app.dto.CommentResponseDTO;
import tmi.app.entity.News;
import tmi.app.entity.NewsLike;
import tmi.app.repository.NewsLikeRepository;
import tmi.app.repository.NewsRepository;
import tmi.app.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import tmi.app.entity.User;
import tmi.app.dto.NewsDetailDto;
import tmi.app.dto.NewsDto;
import java.util.Collections;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import java.util.stream.Collectors;
import org.springframework.data.domain.Sort;

@Service
@RequiredArgsConstructor
public class NewsService {

        private final NewsRepository newsRepository;
        private final NewsLikeRepository newsLikeRepository;
        private final UserRepository userRepository;
        private final CommentService commentService;
        private final NotificationService notificationService;

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
                News news = newsRepository.findById(newsId)
                                .orElseThrow(() -> new RuntimeException("해당 뉴스가 존재하지 않습니다."));

                // 작성자 정보 포함된 NewsData 구성
                NewsDetailDto.NewsData newsData = NewsDetailDto.NewsData.builder()
                                .title(news.getTitle())
                                .content(news.getContent())
                                .createdAt(news.getCreatedAt())
                                .newsTime(news.getNewsTime())
                                .build();

                // 댓글 리스트 가져오기
                List<CommentResponseDTO> comments = commentService.getCommentTree(newsId);

                // 좋아요 수 세기
                int likeCount = newsLikeRepository.countByNews(news);

                boolean liked = newsLikeRepository.existsByNewsAndUser(news, userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("유저 없음")));

                return NewsDetailDto.builder()
                                .newsData(newsData)
                                .comments(comments)
                                .likes(likeCount)
                                .liked(liked)
                                .build();
        }

        // 뉴스 전체 보기
        public List<NewsDto> getNewsListByCategory(String category, int offset, int limit, String sortBy) {
                Pageable pageable;

                switch (sortBy) {
                        case "likes":
                                pageable = PageRequest.of(offset / limit, limit);
                                return newsRepository.findByCategoryOrderByLikeCountDesc(category, pageable);

                        case "comments":
                                pageable = PageRequest.of(offset / limit, limit);
                                return newsRepository.findByCategoryOrderByCommentCountDesc(category, pageable);

                        case "newsTime":
                                pageable = PageRequest.of(offset / limit, limit,
                                                Sort.by(Sort.Direction.DESC, "newsTime"));
                                break;

                        case "createdAt":
                        default:
                                pageable = PageRequest.of(offset / limit, limit,
                                                Sort.by(Sort.Direction.DESC, "createdAt"));
                }

                Page<News> page = newsRepository.findByCategory(category, pageable);

                return page.getContent().stream()
                                .map(news -> new NewsDto(news.getNewsId(), news.getTitle(), news.getContent()))
                                .collect(Collectors.toList());
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

        // 좋아요 추가
        public void likeNews(Long newsId, Long userId) {
                News news = newsRepository.findById(newsId)
                                .orElseThrow(() -> new RuntimeException("뉴스 없음"));
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("유저 없음"));

                // 중복 좋아요 방지
                if (newsLikeRepository.existsByNewsAndUser(news, user)) {
                        throw new RuntimeException("이미 좋아요를 눌렀습니다.");
                }

                NewsLike like = NewsLike.builder()
                                .news(news)
                                .user(user)
                                .createdAt(LocalDateTime.now())
                                .build();

                newsLikeRepository.save(like);
                notificationService.notifyNewsLike(news.getUser(), newsId, user.getNickname());

        }

        // 좋아요 취소
        public void unlikeNews(Long newsId, Long userId) {
                News news = newsRepository.findById(newsId)
                                .orElseThrow(() -> new RuntimeException("뉴스 없음"));
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("유저 없음"));

                newsLikeRepository.deleteByNewsAndUser(news, user);
        }

        // 좋아요 수 조회
        public int getLikeCount(News news) {
                return newsLikeRepository.countByNews(news);
        }
}