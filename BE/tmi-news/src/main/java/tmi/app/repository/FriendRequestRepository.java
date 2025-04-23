package tmi.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tmi.app.entity.FriendRequest;

import java.util.Optional;

public interface FriendRequestRepository extends JpaRepository<FriendRequest, Long> {
    boolean existsByFromUserIdAndToUserId(Long fromId, Long toId);
}
