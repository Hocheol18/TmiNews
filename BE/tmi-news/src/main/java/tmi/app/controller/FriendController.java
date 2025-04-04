package tmi.app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tmi.app.dto.FriendDto;
import tmi.app.security.JwtProvider;
import tmi.app.service.FriendService;
import tmi.app.dto.MyPageResponse;
import tmi.app.service.UserService;


import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/friends")
public class FriendController {

    private final FriendService friendService;
    private final JwtProvider jwtProvider;
    private final UserService userService;

    // 🔹 친구 요청 보내기
    @PostMapping("/request")
    public ResponseEntity<String> sendFriendRequest(
            @RequestHeader("Authorization") String bearerToken,
            @RequestParam Long toUserId) {

        Long fromUserId = extractUserIdFromHeader(bearerToken);
        friendService.sendFriendRequest(fromUserId, toUserId);
        return ResponseEntity.ok("친구 요청을 보냈습니다.");
    }

    // 🔹 친구 요청 수락
    @PostMapping("/accept")
    public ResponseEntity<String> acceptFriendRequest(
            @RequestHeader("Authorization") String bearerToken,
            @RequestParam Long requestId) {

        Long currentUserId = extractUserIdFromHeader(bearerToken);
        friendService.acceptFriendRequest(requestId, currentUserId);
        return ResponseEntity.ok("친구 요청을 수락했습니다.");
    }

    // 🔹 친구 요청 거절
    @PostMapping("/reject")
    public ResponseEntity<String> rejectFriendRequest(
            @RequestHeader("Authorization") String bearerToken,
            @RequestParam Long requestId) {

        Long currentUserId = extractUserIdFromHeader(bearerToken);
        friendService.rejectFriendRequest(requestId, currentUserId);
        return ResponseEntity.ok("친구 요청을 거절했습니다.");
    }

    // 🔹 친구 요청 취소
    @DeleteMapping("/cancel")
    public ResponseEntity<String> cancelFriendRequest(
            @RequestHeader("Authorization") String bearerToken,
            @RequestParam Long requestId) {

        Long currentUserId = extractUserIdFromHeader(bearerToken);
        friendService.cancelFriendRequest(requestId, currentUserId);
        return ResponseEntity.ok("친구 요청을 취소했습니다.");
    }

    // 🔹 친구 목록 조회
    @GetMapping("/list")
    public ResponseEntity<List<FriendDto>> getFriendList(
            @RequestHeader("Authorization") String bearerToken) {

        Long userId = extractUserIdFromHeader(bearerToken);
        List<FriendDto> friends = friendService.getFriendList(userId);
        return ResponseEntity.ok(friends);
    }

    // 🔹 친구 삭제
    @DeleteMapping("/delete")
    public ResponseEntity<String> deleteFriend(
            @RequestHeader("Authorization") String bearerToken,
            @RequestParam Long friendId) {

        Long userId = extractUserIdFromHeader(bearerToken);
        friendService.deleteFriend(userId, friendId);
        return ResponseEntity.ok("친구를 삭제했습니다.");
    }

    // 🔹 친구 마이페이지 조회
    @GetMapping("/{friendId}/mypage")
    public ResponseEntity<MyPageResponse> getFriendPage(
            @PathVariable Long friendId) {

        MyPageResponse response = userService.getFriendPage(friendId);
        return ResponseEntity.ok(response);
    }

    // 🛠 JWT에서 userId 추출하는 공통 메서드
    private Long extractUserIdFromHeader(String bearerToken) {
        String token = bearerToken.replace("Bearer ", "");
        return jwtProvider.extractUserId(token);
    }
}
