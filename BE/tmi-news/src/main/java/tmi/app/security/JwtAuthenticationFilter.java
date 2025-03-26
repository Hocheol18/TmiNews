package tmi.app.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import tmi.app.entity.User;
import tmi.app.repository.UserRepository;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtProvider jwtProvider;
    private final UserRepository userRepository;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        // 1. 요청 헤더에서 Authorization 추출
        String authHeader = request.getHeader("Authorization");

        // 2. 헤더가 없거나 Bearer 형식이 아니면 다음 필터로 넘김
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // 3. JWT 토큰 꺼내기
        String token = authHeader.replace("Bearer ", "");

        try {
            // 4. 토큰에서 userId 추출 및 유저 조회
            Long userId = jwtProvider.extractUserId(token);
            User user = userRepository.findById(userId).orElseThrow();

            // 5. 인증 객체 생성해서 SecurityContext에 등록
            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(user, null, null);
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authentication);

        } catch (Exception e) {
            // 토큰 검증 실패 시 무시하고 다음 필터로 넘김 (인증 실패 → 인증 없는 상태로 진행)
            SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }
}
