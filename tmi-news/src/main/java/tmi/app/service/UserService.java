package tmi.app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tmi.app.dto.MyPageResponse;
import tmi.app.dto.NewsDto;
import tmi.app.entity.User;
import tmi.app.repository.NewsRepository;
import tmi.app.repository.UserRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final NewsRepository newsRepository;

    @Transactional(readOnly = true)
    public MyPageResponse getMyPage(Long userId) {
        // 1. 유저 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        // 2. 유저가 작성한 뉴스 목록 조회
        List<NewsDto> newsList = newsRepository.findByUser(user).stream()
                .map(news -> new NewsDto(news.getNewsId(), news.getTitle(), news.getContent()))
                .toList();

        // 3. DTO로 변환 후 반환
        return MyPageResponse.builder()
                .user(MyPageResponse.UserInfo.builder()
                        .nickname(user.getNickname())
                        .profileImage(user.getProfileImage())
                        .build())
                .newsList(newsList)
                .build();
    }
}
