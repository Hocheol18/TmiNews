package tmi.app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tmi.app.dto.NotificationDto;
import tmi.app.security.JwtProvider;
import tmi.app.service.NotificationService;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/notifications")
public class NotificationController {

    private final NotificationService notificationService;
    private final JwtProvider jwtProvider;

    // 안 읽은 알림 조회
    @GetMapping("/unread")
    public ResponseEntity<List<NotificationDto>> getUnread(@RequestHeader("Authorization") String bearerToken) {
        Long userId = jwtProvider.extractUserId(bearerToken.replace("Bearer ", ""));
        return ResponseEntity.ok(notificationService.getUnreadNotifications(userId));
    }

    // 알림 읽음 처리
    @PostMapping("/{notificationId}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable Long notificationId) {
        notificationService.markAsRead(notificationId);
        return ResponseEntity.ok().build();
    }

    // 알림 전체 조회
    @GetMapping
    public ResponseEntity<List<NotificationDto>> getNotifications(@RequestHeader("Authorization") String bearerToken) {
        Long userId = jwtProvider.extractUserId(bearerToken.replace("Bearer ", ""));
        return ResponseEntity.ok(notificationService.getNotifications(userId));
    }

    // 알림 수동 삭제
    @DeleteMapping("/{notificationId}")
    public ResponseEntity<Void> delete(@PathVariable Long notificationId) {
        notificationService.deleteById(notificationId);
        return ResponseEntity.ok().build();
    }
}
