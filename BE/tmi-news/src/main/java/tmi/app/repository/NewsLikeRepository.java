package tmi.app.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import tmi.app.entity.News;
import tmi.app.entity.User;
import tmi.app.entity.NewsLike;

public interface NewsLikeRepository extends JpaRepository<NewsLike, Long> {
    boolean existsByNewsAndUser(News news, User user);
    void deleteByNewsAndUser(News news, User user);
    int countByNews(News news);
}
