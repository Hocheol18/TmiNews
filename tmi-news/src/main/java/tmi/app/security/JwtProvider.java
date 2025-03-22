package tmi.app.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;
import tmi.app.entity.User;

import java.security.Key;
import java.util.Date;

@Component
public class JwtProvider {

    private Key key;

    private final long ACCESS_TOKEN_EXPIRATION = 1000L * 60 * 60;        // 1시간
    private final long REFRESH_TOKEN_EXPIRATION = 1000L * 60 * 60 * 24 * 7; // 7일

    @PostConstruct
    public void init() {
        // 간단하게 HS256 알고리즘을 위한 key 생성 (실무에서는 key 관리 분리 권장)
        this.key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
    }

    public String createAccessToken(User user) {
        return createToken(user, ACCESS_TOKEN_EXPIRATION);
    }

    public String createRefreshToken(User user) {
        return createToken(user, REFRESH_TOKEN_EXPIRATION);
    }

    private String createToken(User user, long expirationTime) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + expirationTime);

        return Jwts.builder()
                .setSubject(user.getUserId().toString())
                .claim("nickname", user.getNickname())
                .claim("oauthId", user.getOauthId())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(key)
                .compact();
    }
    public Long extractUserId(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();

        return Long.parseLong(claims.getSubject());
    }
}
