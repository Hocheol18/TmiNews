package tmi.app.repository;

import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import tmi.app.entity.Friendship;

import java.util.List;

public interface FriendshipRepository extends JpaRepository<Friendship, Long> {

    // 특정 유저의 친구 목록 조회
    List<Friendship> findAllByUserUserId(Long userId);

    // 특정 친구 관계가 이미 존재하는지 확인
    boolean existsByUserUserIdAndFriendUserId(Long userId, Long friendId);

    // 친구 관계 삭제용 (언프렌드 기능에 사용 가능)
    void deleteByUserUserIdAndFriendUserId(Long userId, Long friendId);

    // 특정 유저의 친구 중에서 닉네임으로 검색
    @Query("SELECT f FROM Friendship f WHERE f.user.userId = :userId AND f.friend.nickname LIKE %:keyword%")
    List<Friendship> searchFriendsByNickname(@Param("userId") Long userId, @Param("keyword") String keyword);


}
