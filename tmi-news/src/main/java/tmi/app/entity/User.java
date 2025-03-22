package tmi.app.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;


@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    private String oauthId;
    private String email;
    private String nickname;
    private String profileImage;

    private String accessToken;
    private String refreshToken;
    private Integer expiresAt;
}
