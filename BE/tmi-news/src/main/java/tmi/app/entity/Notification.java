package tmi.app.entity;

import jakarta.persistence.*;
import lombok.*;
import tmi.app.entity.enums.NotificationType;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String message;

    private boolean isRead;

    private LocalDateTime createdAt;

    private LocalDateTime expiresAt; // 1주 후 자동 삭제 용도

    @Enumerated(EnumType.STRING)
    private NotificationType type;

    private Long targetId; // 친구 요청 ID, 뉴스 ID 등
    private Long targetUserId; // 친구 마이페이지 이동용 (선택사항)

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id")
    private User receiver;

    @PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.expiresAt = createdAt.plusDays(7); // 기본 유효기간 1주
    }
}
