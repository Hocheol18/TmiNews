package tmi.app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import tmi.app.dto.KakaoLoginRequest;
import tmi.app.dto.JwtResponse;
import tmi.app.service.AuthService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    // 카카오 로그인
    @PostMapping("/kakao")
    public JwtResponse kakaoLogin(@RequestBody KakaoLoginRequest request) {
        return authService.kakaoLogin(request.getCode());
    }

    // 리프레시 토큰
    @PostMapping("/refresh")
    public JwtResponse refreshAccessToken(@RequestHeader("Authorization") String bearerToken) {
        String refreshToken = bearerToken.replace("Bearer ", "");
        return authService.refreshAccessToken(refreshToken);
    }

    // 앱 로그아웃
    @PostMapping("/logout")
    public void logout(@RequestHeader("Authorization") String bearerToken) {
        String refreshToken = bearerToken.replace("Bearer ", "");
        authService.logout(refreshToken);
    }
}
