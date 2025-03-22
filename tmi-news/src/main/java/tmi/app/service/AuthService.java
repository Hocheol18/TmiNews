package tmi.app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tmi.app.dto.JwtResponse;
import tmi.app.entity.User;
import tmi.app.exception.InvalidKakaoAuthCodeException;
import tmi.app.exception.InvalidRefreshTokenException;
import tmi.app.repository.UserRepository;
import tmi.app.oauth.KakaoOAuthClient;
import tmi.app.oauth.KakaoTokenResponse;
import tmi.app.oauth.KakaoUserResponse;
import tmi.app.security.JwtProvider;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final KakaoOAuthClient kakaoOAuthClient;
    private final UserRepository userRepository;
    private final JwtProvider jwtProvider;

    @Transactional
    public JwtResponse kakaoLogin(String code) {
        try {
            // 1. 카카오에서 access_token + refresh_token 받아오기
            KakaoTokenResponse tokenResponse = kakaoOAuthClient.getToken(code);

            // 2. access_token으로 사용자 정보 받아오기
            KakaoUserResponse userInfo = kakaoOAuthClient.getUserInfo(tokenResponse.getAccessToken());

            // 3. DB에 사용자 저장 or 로그인
            User user = userRepository.findByOauthId(String.valueOf(userInfo.getId()))
                    .orElseGet(() -> {
                        User newUser = User.builder()
                                .oauthId(String.valueOf(userInfo.getId()))
                                .nickname(userInfo.getNickname())
                                .profileImage(userInfo.getProfileImageUrl())
                                .build();
                        return userRepository.save(newUser);
                    });

            // 4. access / refresh JWT 발급
            String accessToken = jwtProvider.createAccessToken(user);
            String refreshToken = jwtProvider.createRefreshToken(user);

            // 5. refreshToken DB에도 저장
            user.setRefreshToken(refreshToken);
            userRepository.save(user);

            // 6. 프론트에 응답
            return new JwtResponse(accessToken, refreshToken);

        } catch (Exception e) {
            // 👇 여기서 400으로 응답 처리
            throw new InvalidKakaoAuthCodeException("잘못된 인가 코드이거나 이미 사용된 코드입니다.");
        }
    }

    @Transactional
    public JwtResponse refreshAccessToken(String refreshToken) {
        // 1. refreshToken 검증 (parse해서 userId 추출)
        Long userId = jwtProvider.extractUserId(refreshToken);

        // 2. DB에서 사용자 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("유저를 찾을 수 없습니다."));

        // 3. DB에 저장된 refreshToken과 비교
        if (!refreshToken.equals(user.getRefreshToken())) {
            throw new InvalidRefreshTokenException("유효하지 않은 refresh token 입니다.");
        }

        // 4. 새 access token 발급
        String newAccessToken = jwtProvider.createAccessToken(user);

        // 5. 응답
        return new JwtResponse(newAccessToken, refreshToken); // refreshToken은 그대로 보냄
    }

    @Transactional
    public void logout(String refreshToken) {
        // 1. refreshToken 검증
        Long userId = jwtProvider.extractUserId(refreshToken);

        // 2. 유저 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("유저를 찾을 수 없습니다."));

        // 3. 저장된 refreshToken과 비교
        if (!refreshToken.equals(user.getRefreshToken())) {
            throw new InvalidRefreshTokenException("유효하지 않은 refresh token 입니다.");
        }

        // 4. refreshToken 초기화 (실질적 로그아웃)
        user.setRefreshToken(null);
        userRepository.save(user);
    }

}
