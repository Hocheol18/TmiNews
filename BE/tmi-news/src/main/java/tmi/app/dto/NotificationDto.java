package tmi.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import tmi.app.entity.enums.NotificationType;

import java.time.LocalDateTime;

@Getter
@Builder
@AllArgsConstructor
public class NotificationDto {
    private Long id;
    private String message;
    private NotificationType type;
    private Long targetId; // 클릭 시 이동할 ID (뉴스 ID 등)
    private Long targetUserId;
    private boolean isRead;
    private LocalDateTime createdAt;
}
