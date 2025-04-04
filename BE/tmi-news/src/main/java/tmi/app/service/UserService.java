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

    // 내 마이페이지 조회
    @Transactional(readOnly = true)
    public MyPageResponse getMyPage(Long userId) {
        return buildMyPageResponse(userId);
    }

    // 친구 마이페이지 조회
    @Transactional(readOnly = true)
    public MyPageResponse getFriendPage(Long friendId) {
        return buildMyPageResponse(friendId);
    }

    // 공통 로직 추출
    private MyPageResponse buildMyPageResponse(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        List<NewsDto> newsList = newsRepository.findByUser(user).stream()
                .map(news -> new NewsDto(news.getNewsId(), news.getTitle(), news.getContent()))
                .toList();

        return MyPageResponse.builder()
                .user(MyPageResponse.UserInfo.builder()
                        .nickname(user.getNickname())
                        .profileImage(user.getProfileImage())
                        .build())
                .newsList(newsList)
                .build();
    }
}
