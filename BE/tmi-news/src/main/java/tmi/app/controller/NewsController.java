package tmi.app.controller;

import org.springframework.core.ParameterizedTypeReference;
import tmi.app.dto.NewsPreviewRequest;
import tmi.app.dto.NewsPreviewResponse;
import tmi.app.dto.NewsRegisterRequest;
import tmi.app.service.NewsService;
import tmi.app.security.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import tmi.app.entity.User;
import tmi.app.repository.UserRepository;
import java.util.HashMap;
import tmi.app.dto.NewsDetailDto;
import tmi.app.dto.NewsDto;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/news")
public class NewsController {

  private final WebClient webClient;
  private final NewsService newsService;
  private final JwtProvider jwtProvider;
  private static final Logger logger = LoggerFactory.getLogger(NewsController.class);
  private final UserRepository userRepository;

  @PostMapping("/preview")
  public ResponseEntity<NewsPreviewResponse> previewNews(
      @RequestHeader("Authorization") String bearerToken,
      @RequestBody NewsPreviewRequest request) {

    // JWT 검증 전 로그 찍기
    String token = bearerToken.replace("Bearer ", "");
    logger.info("JWT 토큰 추출: {}", token);

    Long userId = jwtProvider.extractUserId(token);
    logger.info("토큰으로 추출한 userId: {}", userId);

    // 1) category 유효성 체크
    String[] categories = { "IT", "연예", "스포츠", "사회", "건강", "재테크" };
    boolean validCategory = false;
    for (String c : categories) {
      if (c.equals(request.getCategory())) {
        validCategory = true;
        break;
      }
    }
    if (!validCategory) {
      logger.warn("유효하지 않은 카테고리: {}", request.getCategory());
      return ResponseEntity.badRequest().build(); // 400
    }

    // 2) news_time이 null이면 현재시간으로 대체
    String newsTime = request.getNewsTime();
    if (newsTime == null || newsTime.isEmpty()) {
      newsTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
    logger.info("뉴스 시간: {}", newsTime);

    // 3) AI 서버 호출
    logger.info("AI 서버 호출 시작");
    Map<String, String> aiResponse = webClient.post()
        .uri("/generate")
        .bodyValue(Map.of(
            "title", request.getTitle(),
            "content", request.getContent(),
            "category", request.getCategory()))
        .retrieve()
        .bodyToMono(new ParameterizedTypeReference<Map<String, String>>() {
        })
        .block();

    logger.info("AI 서버 응답: {}", aiResponse);

    // 4) 응답 해석 및 반환
    String generatedTitle = aiResponse.get("generated_title");
    String generatedContent = aiResponse.get("generated_content");

    NewsPreviewResponse response = new NewsPreviewResponse();
    response.setTitle(generatedTitle);
    response.setContent(generatedContent);
    response.setCategory(request.getCategory());
    response.setNewsTime(newsTime);

    logger.info("응답 반환 완료");
    return ResponseEntity.ok(response);
  }

  @PostMapping
  public ResponseEntity<?> registerNews(@RequestHeader("Authorization") String bearerToken,
      @RequestBody NewsRegisterRequest request) {
    // JWT에서 토큰 추출 후 userId 조회
    String token = bearerToken.replace("Bearer ", "");
    Long userId = jwtProvider.extractUserId(token);
    logger.info("토큰으로 추출한 userId: {}", userId);

    User user = userRepository.findById(userId)
        .orElseThrow(() -> new RuntimeException("User not found"));

    // NewsService에 User 객체를 함께 전달
    newsService.registerNews(request, user);
    return ResponseEntity.status(201).build();
  }

  @GetMapping("/{newsId}")
  public ResponseEntity<?> getNewsDetail(
      @RequestHeader("Authorization") String bearerToken,
      @PathVariable Long newsId) {

    String token = bearerToken.replace("Bearer ", "");
    Long userId = jwtProvider.extractUserId(token);

    NewsDetailDto dto = newsService.getNewsDetail(newsId, userId);

    // 원하는 구조대로 직접 펼쳐서 Map 구성
    Map<String, Object> data = new HashMap<>();
    data.put("title", dto.getNewsData().getTitle());
    data.put("content", dto.getNewsData().getContent());
    data.put("createdAt", dto.getNewsData().getCreatedAt());
    data.put("newsTime", dto.getNewsData().getNewsTime());
    data.put("comments", dto.getComments());
    data.put("likes", dto.getLikes());
    data.put("liked", dto.isLiked());

    Map<String, Object> response = new HashMap<>();
    response.put("status", 200);
    response.put("message", "뉴스페이지 조회 성공");
    response.put("data", data);

    return ResponseEntity.ok(response);
  }

  @GetMapping("/list")
  public ResponseEntity<?> getNewsListByCategory(
      @RequestParam String category,
      @RequestParam(defaultValue = "0") int offset,
      @RequestParam(defaultValue = "9") int limit,
      @RequestParam(defaultValue = "createdAt") String sort) {
    List<NewsDto> newsList = newsService.getNewsListByCategory(category, offset, limit, sort);

    Map<String, Object> response = new HashMap<>();
    response.put("status", 200);
    response.put("message", "카테고리별 뉴스 조회 성공");
    response.put("data", newsList);

    return ResponseEntity.ok(response);
  }

  @PostMapping("/{newsId}/likes")
  public ResponseEntity<Void> likeNews(@PathVariable Long newsId,
      @RequestHeader("Authorization") String bearerToken) {
    String token = bearerToken.replace("Bearer ", "");
    Long userId = jwtProvider.extractUserId(token);

    newsService.likeNews(newsId, userId);
    return ResponseEntity.ok().build();
  }

  @DeleteMapping("/{newsId}/likes")
  public ResponseEntity<Void> unlikeNews(@PathVariable Long newsId,
      @RequestHeader("Authorization") String bearerToken) {
    String token = bearerToken.replace("Bearer ", "");
    Long userId = jwtProvider.extractUserId(token);

    newsService.unlikeNews(newsId, userId);
    return ResponseEntity.ok().build();
  }

}
