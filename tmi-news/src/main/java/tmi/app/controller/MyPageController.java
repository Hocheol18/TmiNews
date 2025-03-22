package tmi.app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import tmi.app.dto.MyPageResponse;
import tmi.app.entity.User;
import tmi.app.repository.UserRepository;
import tmi.app.security.JwtProvider;
import tmi.app.service.UserService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MyPageController {

    private final JwtProvider jwtProvider;
    private final UserService userService;

    @GetMapping
    public MyPageResponse getMyPage(@RequestHeader("Authorization") String bearerToken) {
        String token = bearerToken.replace("Bearer ", "");
        Long userId = jwtProvider.extractUserId(token);

        return userService.getMyPage(userId);
    }
}
