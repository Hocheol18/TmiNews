package tmi.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tmi.app.entity.Notification;
import tmi.app.entity.enums.NotificationType;

import java.time.LocalDateTime;
import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByReceiverUserIdAndIsReadFalse(Long userId);
    List<Notification> findByReceiverUserId(Long userId);

    // 자동 삭제용
    void deleteByExpiresAtBefore(LocalDateTime now);

    // 특정 타입과 대상 ID로 삭제 (친구 요청 수락 시)
    void deleteByTargetIdAndType(Long targetId, NotificationType type);

}
