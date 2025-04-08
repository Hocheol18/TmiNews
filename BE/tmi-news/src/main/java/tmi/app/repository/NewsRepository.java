package tmi.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import tmi.app.dto.NewsDto;
import tmi.app.entity.News;

import java.util.List;

public interface NewsRepository extends JpaRepository<News, Long> {

    // 특정 유저가 작성한 뉴스 전체 조회
    List<News> findByUser(tmi.app.entity.User user);

    // 🔹 최신순 정렬
    @Query("SELECT new tmi.app.dto.NewsDto(n.newsId, n.title, n.content) " +
            "FROM News n WHERE n.user.userId = :userId " +
            "ORDER BY n.createdAt DESC")
    List<NewsDto> findAllOrderByCreatedAtDesc(@Param("userId") Long userId);

    // 🔹 댓글 수 기준 정렬
    @Query("SELECT new tmi.app.dto.NewsDto(n.newsId, n.title, n.content) " +
            "FROM News n LEFT JOIN n.comments c " +
            "WHERE n.user.userId = :userId " +
            "GROUP BY n.newsId " +
            "ORDER BY COUNT(c) DESC")
    List<NewsDto> findAllOrderByCommentCount(@Param("userId") Long userId);
}
