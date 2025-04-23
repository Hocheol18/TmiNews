package tmi.app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import tmi.app.dto.UserSearchDto;
import tmi.app.entity.User;
import tmi.app.repository.UserRepository;
import tmi.app.security.JwtProvider;
import tmi.app.service.UserService;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final JwtProvider jwtProvider;
    private final UserRepository userRepository;
    private final UserService userService;

    @GetMapping("/me")
    public Map<String, Object> getMyInfo(@RequestHeader("Authorization") String bearerToken) {
        String token = bearerToken.replace("Bearer ", "");
        Long userId = jwtProvider.extractUserId(token);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        return Map.of(
                "nickname", user.getNickname(),
                "profileImage", user.getProfileImage(),
                "oauthId", user.getOauthId()
        );
    }

    // 유저 검색 API 추가
    @GetMapping("/search")
    public List<UserSearchDto> searchUsers(
            @RequestHeader("Authorization") String bearerToken,
            @RequestParam String keyword) {

        String token = bearerToken.replace("Bearer ", "");
        Long currentUserId = jwtProvider.extractUserId(token);

        return userService.searchUsers(keyword, currentUserId);
    }
}
