package tmi.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tmi.app.entity.User;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByOauthId(String oauthId);

    // 닉네임에 키워드가 포함되면서 본인은 제외
    List<User> findByNicknameContainingIgnoreCaseAndUserIdNot(String keyword, Long excludeUserId);
}