package tmi.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import tmi.app.entity.Comment;

import java.util.List;
import java.util.Optional;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    @Query("SELECT c FROM Comment c JOIN FETCH c.user JOIN FETCH c.news WHERE c.replyId = :replyId")
    Optional<Comment> findByIdWithUserAndNews(@Param("replyId") Long replyId);

    @Query("SELECT c FROM Comment c JOIN FETCH c.user JOIN FETCH c.news WHERE c.news.newsId = :newsId ORDER BY c.createdAt ASC")
    List<Comment> findAllByNewsIdWithUser(@Param("newsId") Long newsId);


}
