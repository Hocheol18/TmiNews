package tmi.app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tmi.app.dto.MyPageResponse;
import tmi.app.dto.NewsDto;
import tmi.app.dto.UserSearchDto;
import tmi.app.entity.User;
import tmi.app.repository.FriendshipRepository;
import tmi.app.repository.NewsRepository;
import tmi.app.repository.UserRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final NewsRepository newsRepository;
    private final FriendshipRepository friendshipRepository;

    // 🔹 내 마이페이지 조회
    @Transactional(readOnly = true)
    public MyPageResponse getMyPage(Long userId, String sortBy) {
        return buildMyPageResponse(userId, sortBy);
    }

    // 🔹 친구 마이페이지 조회
    @Transactional(readOnly = true)
    public MyPageResponse getFriendPage(Long friendId, String sortBy) {
        return buildMyPageResponse(friendId, sortBy);
    }

    // ✅ 공통 로직 추출 (정렬 & 친구 수 포함)
    private MyPageResponse buildMyPageResponse(Long userId, String sortBy) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        // 정렬 기준에 따라 뉴스 조회
        List<NewsDto> newsList;
        if ("comment".equals(sortBy)) {
            newsList = newsRepository.findAllOrderByCommentCount(userId);
        } else {
            // 기본은 최신순
            newsList = newsRepository.findAllOrderByCreatedAtDesc(userId);
        }

        // 친구 수 계산
        int friendCount = friendshipRepository.findAllByUserUserId(userId).size();

        return MyPageResponse.builder()
                .user(MyPageResponse.UserInfo.builder()
                        .nickname(user.getNickname())
                        .profileImage(user.getProfileImage())
                        .build())
                .friendCount(friendCount)
                .newsList(newsList)
                .build();

    }

    // 🔍 유저 검색
    @Transactional(readOnly = true)
    public List<UserSearchDto> searchUsers(String keyword, Long currentUserId) {
        return userRepository.findByNicknameContainingIgnoreCaseAndUserIdNot(keyword, currentUserId).stream()
                .map(user -> new UserSearchDto(user.getUserId(), user.getNickname(), user.getProfileImage()))
                .toList();
    }
}
