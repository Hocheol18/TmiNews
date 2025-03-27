package tmi.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tmi.app.entity.News;
import tmi.app.entity.User;

import java.util.List;

public interface NewsRepository extends JpaRepository<News, Long> {
    List<News> findByUser(User user);
}
