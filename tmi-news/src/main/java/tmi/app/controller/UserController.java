package tmi.app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import tmi.app.entity.User;
import tmi.app.repository.UserRepository;
import tmi.app.security.JwtProvider;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final JwtProvider jwtProvider;
    private final UserRepository userRepository;

    @GetMapping("/me")
    public Map<String, Object> getMyInfo(@RequestHeader("Authorization") String bearerToken) {
        // "Bearer {token}" 형식에서 "Bearer " 제거
        String token = bearerToken.replace("Bearer ", "");

        // JWT에서 userId 추출
        Long userId = jwtProvider.extractUserId(token);

        // DB에서 사용자 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        return Map.of(
                "nickname", user.getNickname(),
                "profileImage", user.getProfileImage(),
                "oauthId", user.getOauthId()
        );
    }
}
