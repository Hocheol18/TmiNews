package tmi.app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

import tmi.app.dto.FriendDto;
import tmi.app.dto.UserSearchDto;
import tmi.app.entity.FriendRequest;
import tmi.app.entity.Friendship;
import tmi.app.entity.Notification;
import tmi.app.entity.User;
import tmi.app.entity.enums.NotificationType;
import tmi.app.repository.FriendRequestRepository;
import tmi.app.repository.FriendshipRepository;
import tmi.app.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class FriendService {

    private final UserRepository userRepository;
    private final FriendRequestRepository friendRequestRepository;
    private final FriendshipRepository friendshipRepository;
    private final NotificationService notificationService;

    // 친구 요청 보내기
    @Transactional
    public void sendFriendRequest(Long fromUserId, Long toUserId) {
        if (fromUserId.equals(toUserId)) {
            throw new IllegalArgumentException("자기 자신에게 친구 요청을 보낼 수 없습니다.");
        }

        User fromUser = userRepository.findById(fromUserId)
                .orElseThrow(() -> new IllegalArgumentException("요청 유저를 찾을 수 없습니다."));
        User toUser = userRepository.findById(toUserId)
                .orElseThrow(() -> new IllegalArgumentException("대상 유저를 찾을 수 없습니다."));

        if (friendRequestRepository.existsByFromUserIdAndToUserId(fromUserId, toUserId)) {
            throw new IllegalArgumentException("이미 친구 요청을 보냈습니다.");
        }

        FriendRequest request = new FriendRequest(fromUser, toUser);
        friendRequestRepository.save(request);

        // 친구 요청 알림 생성
        notificationService.createNotification(
                toUser,
                fromUser.getNickname() + "님이 친구 요청을 보냈습니다.",
                NotificationType.FRIEND_REQUEST,
                request.getFriendRequestId() // 생성 후 ID 사용
        );
    }

    // 친구 요청 수락
    @Transactional
    public void acceptFriendRequest(Long requestId, Long currentUserId) {
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("친구 요청을 찾을 수 없습니다."));

        if (!request.getTo().getUserId().equals(currentUserId)) {
            throw new IllegalStateException("해당 요청을 수락할 권한이 없습니다.");
        }

        request.setStatus(FriendRequest.RequestStatus.ACCEPTED);
        friendRequestRepository.save(request);

        // 양방향 친구 관계 저장
        Friendship f1 = new Friendship(request.getFrom(), request.getTo());
        Friendship f2 = new Friendship(request.getTo(), request.getFrom());
        friendshipRepository.save(f1);
        friendshipRepository.save(f2);

        // 기존 친구 요청 알림 삭제
        notificationService.deleteByTargetIdAndType(request.getFriendRequestId(), NotificationType.FRIEND_REQUEST);

        // 친구 수락 알림 전송 (보낸 사람에게)
        User fromUser = request.getFrom();
        User toUser = request.getTo();

        notificationService.createNotification(
                fromUser,
                toUser.getNickname() + "님과 친구가 되었습니다!",
                NotificationType.FRIEND_ACCEPTED,
                request.getFriendRequestId(),   // targetId
                toUser.getUserId()              // targetUserId
        );
    }


    // 친구 요청 거절
    @Transactional
    public void rejectFriendRequest(Long requestId, Long currentUserId) {
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("친구 요청을 찾을 수 없습니다."));

        if (!request.getTo().getUserId().equals(currentUserId)) {
            throw new IllegalStateException("해당 요청을 거절할 권한이 없습니다.");
        }

        request.setStatus(FriendRequest.RequestStatus.REJECTED);
        friendRequestRepository.save(request);

        // 기존 친구 요청 알림 삭제
        notificationService.deleteByTargetIdAndType(request.getFriendRequestId(), NotificationType.FRIEND_REQUEST);
    }

    // 친구 요청 취소
    @Transactional
    public void cancelFriendRequest(Long requestId, Long currentUserId) {
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("친구 요청을 찾을 수 없습니다."));

        if (!request.getFrom().getUserId().equals(currentUserId)) {
            throw new IllegalStateException("해당 요청을 취소할 권한이 없습니다.");
        }

        friendRequestRepository.delete(request);
    }

    // 친구 목록 조회
    @Transactional(readOnly = true)
    public List<FriendDto> getFriendList(Long userId) {
        List<Friendship> friendships = friendshipRepository.findAllByUserUserId(userId);
        return friendships.stream()
                .map(f -> new FriendDto(f.getFriend()))
                .toList();
    }

    // 친구 삭제
    @Transactional
    public void deleteFriend(Long userId, Long friendId) {
        friendshipRepository.deleteByUserUserIdAndFriendUserId(userId, friendId);
        friendshipRepository.deleteByUserUserIdAndFriendUserId(friendId, userId);
    }

    // 내 친구 중 검색
    @Transactional(readOnly = true)
    public List<UserSearchDto> searchMyFriends(Long userId, String keyword) {
        return friendshipRepository.searchFriendsByNickname(userId, keyword).stream()
                .map(friendship -> {
                    User friend = friendship.getFriend();
                    return new UserSearchDto(friend.getUserId(), friend.getNickname(), friend.getProfileImage());
                })
                .toList();
    }
}
