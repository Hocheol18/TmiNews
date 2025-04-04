package tmi.app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

import tmi.app.dto.FriendDto;
import tmi.app.entity.FriendRequest;
import tmi.app.entity.Friendship;
import tmi.app.entity.User;
import tmi.app.repository.FriendRequestRepository;
import tmi.app.repository.FriendshipRepository;
import tmi.app.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class FriendService {

    private final UserRepository userRepository;
    private final FriendRequestRepository friendRequestRepository;
    private final FriendshipRepository friendshipRepository;

    @Transactional
    public void sendFriendRequest(Long fromUserId, Long toUserId) {
        // 자기 자신에게 친구 요청 불가
        if (fromUserId.equals(toUserId)) {
            throw new IllegalArgumentException("자기 자신에게 친구 요청을 보낼 수 없습니다.");
        }

        // 유저 조회
        User fromUser = userRepository.findById(fromUserId)
                .orElseThrow(() -> new IllegalArgumentException("요청 유저를 찾을 수 없습니다."));
        User toUser = userRepository.findById(toUserId)
                .orElseThrow(() -> new IllegalArgumentException("대상 유저를 찾을 수 없습니다."));

        // 이미 요청 보냈는지 확인
        if (friendRequestRepository.existsByFromUserIdAndToUserId(fromUserId, toUserId)) {
            throw new IllegalArgumentException("이미 친구 요청을 보냈습니다.");
        }

        // 요청 저장
        FriendRequest request = new FriendRequest(fromUser, toUser);
        friendRequestRepository.save(request);
    }
    // 친구 요청 수락
    @Transactional
    public void acceptFriendRequest(Long requestId, Long currentUserId) {
        // 1. 요청 조회
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("친구 요청을 찾을 수 없습니다."));

        // 2. 요청 받은 사람이 현재 유저인지 확인
        if (!request.getTo().getUserId().equals(currentUserId)) {
            throw new IllegalStateException("해당 요청을 수락할 권한이 없습니다.");
        }

        // 3. 상태 변경
        request.setStatus(FriendRequest.RequestStatus.ACCEPTED);
        friendRequestRepository.save(request);

        // 4. 양방향 Friendship 저장
        Friendship f1 = new Friendship(request.getFrom(), request.getTo());
        Friendship f2 = new Friendship(request.getTo(), request.getFrom());
        friendshipRepository.save(f1);
        friendshipRepository.save(f2);
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
        // 친구 관계 엔티티 조회
        List<Friendship> friendships = friendshipRepository.findAllByUserUserId(userId);

        // 친구 정보만 FriendDto로 변환하여 반환
        return friendships.stream()
                .map(f -> new FriendDto(f.getFriend()))
                .toList();
    }
    // 친구 삭제
    @Transactional
    public void deleteFriend(Long userId, Long friendId) {
        // 양방향 관계 모두 삭제
        friendshipRepository.deleteByUserUserIdAndFriendUserId(userId, friendId);
        friendshipRepository.deleteByUserUserIdAndFriendUserId(friendId, userId);
    }

}
