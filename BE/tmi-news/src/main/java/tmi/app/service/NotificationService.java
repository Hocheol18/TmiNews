package tmi.app.service;

import org.springframework.scheduling.annotation.Scheduled;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tmi.app.dto.NotificationDto;
import tmi.app.entity.Notification;
import tmi.app.entity.User;
import tmi.app.entity.enums.NotificationType;
import tmi.app.repository.NotificationRepository;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;

    // 1. 뉴스나 친구 요청 알림 (userId 없이)
    @Transactional
    public void createNotification(User receiver, String message, NotificationType type, Long targetId) {
        createNotification(receiver, message, type, targetId, null);
    }

    // 2. 친구 요청 알림 (userId 포함)
    @Transactional
    public void createNotification(User receiver, String message, NotificationType type, Long targetId, Long targetUserId) {
        Notification notification = Notification.builder()
                .receiver(receiver)
                .message(message)
                .isRead(false)
                .type(type)
                .targetId(targetId)
                .targetUserId(targetUserId)
                .build();
        notificationRepository.save(notification);
    }

    // 뉴스에 좋아요 알림
    public void notifyNewsLike(User receiver, Long newsId, String likerName) {
        createNotification(receiver, likerName + "님이 뉴스에 좋아요를 눌렀습니다.", NotificationType.LIKE, newsId);
    }

    // 뉴스에 댓글 알림
    public void notifyNewsComment(User receiver, Long newsId, String commenterName) {
        createNotification(receiver, commenterName + "님이 뉴스에 댓글을 남겼습니다.", NotificationType.COMMENT, newsId);
    }


    // 안 읽은 알림 목록 조회
    @Transactional(readOnly = true)
    public List<NotificationDto> getUnreadNotifications(Long userId) {
        return notificationRepository.findByReceiverUserIdAndIsReadFalse(userId).stream()
                .map(n -> new NotificationDto(
                        n.getId(),
                        n.getMessage(),
                        n.getType(),
                        n.getTargetId(),
                        n.getTargetUserId(),
                        n.isRead(),
                        n.getCreatedAt()
                ))
                .toList();
    }

    // 알림 읽음 처리
    @Transactional
    public void markAsRead(Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 알림입니다."));
        notification.setRead(true);
    }

    @Transactional
    public void deleteByTargetIdAndType(Long targetId, NotificationType type) {
        notificationRepository.deleteByTargetIdAndType(targetId, type);
    }

    // 전체 알림 조회
    @Transactional(readOnly = true)
    public List<NotificationDto> getNotifications(Long userId) {
        return notificationRepository.findByReceiverUserId(userId).stream()
                .map(n -> new NotificationDto(
                        n.getId(),
                        n.getMessage(),
                        n.getType(),
                        n.getTargetId(),
                        n.getTargetUserId(),
                        n.isRead(),
                        n.getCreatedAt()
                ))
                .toList();
    }

    // 알림 삭제
    @Transactional
    public void deleteById(Long notificationId) {
        notificationRepository.deleteById(notificationId);
    }


    // 주기적으로 오래된 알림 삭제
    @Transactional
    public void deleteExpiredNotifications() {
        notificationRepository.deleteByExpiresAtBefore(LocalDateTime.now());
    }

    @Scheduled(cron = "0 0 3 * * *") // 매일 새벽 3시 실행
    public void runAutoDelete() {
        deleteExpiredNotifications();
    }

}
