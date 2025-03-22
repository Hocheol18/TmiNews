package tmi.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tmi.app.entity.User;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByOauthId(String oauthId);
}