package tmi.app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tmi.app.dto.CommentRequestDTO;
import tmi.app.dto.CommentResponseDTO;
import tmi.app.dto.CommentUpdateRequestDTO;
import tmi.app.entity.Comment;
import tmi.app.entity.News;
import tmi.app.entity.User;
import tmi.app.repository.CommentRepository;
import tmi.app.repository.NewsRepository;
import tmi.app.repository.UserRepository;
import tmi.app.security.JwtProvider;
import tmi.app.exception.CustomException;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final NewsRepository newsRepository;
    private final JwtProvider jwtProvider;

    public CommentResponseDTO createComment(Long newsId, CommentRequestDTO request, String token) {
        Long userId = jwtProvider.extractUserId(token);
        System.out.println("추출된 userId = " + userId);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException("존재하지 않는 사용자입니다."));
        News news = newsRepository.findById(newsId)
                .orElseThrow(() -> new CustomException("존재하지 않는 뉴스입니다."));

        Comment comment = Comment.builder()
                .content(request.getContent())
                .createdAt(LocalDateTime.now())
                .user(user)
                .news(news)
                .parentId(request.getParentId())
                .build();

        Comment saved = commentRepository.save(comment);

        return CommentResponseDTO.builder()
                .replyId(saved.getReplyId())
                .newsId(news.getNewsId())
                .content(saved.getContent())
                .createdAt(saved.getCreatedAt())
                .user(CommentResponseDTO.WriterDTO.builder()
                        .userId(user.getUserId())
                        .nickname(user.getNickname())
                        .profileImage(user.getProfileImage())
                        .build())
                .build();
    }

    @Transactional
    public CommentResponseDTO updateComment(Long newsId, Long replyId, CommentUpdateRequestDTO request, String token) {
        Long userId = jwtProvider.extractUserId(token);

        Comment comment = commentRepository.findByIdWithUserAndNews(replyId)
                .orElseThrow(() -> new CustomException("존재하지 않는 댓글입니다."));

        System.out.println("🔐 login userId: " + userId);
        System.out.println("💬 who comment: " + comment.getUser());
        System.out.println("💬 comment ID: " + comment.getUser().getUserId());
        System.out.println("✅ reply newsId: " + comment.getNews().getNewsId());
        System.out.println("🆚 request newsId: " + newsId);
        System.out.println("📌 findByIdWithUserAndNews() called!");

        if (!comment.getUser().getUserId().equals(userId)) {
            throw new CustomException("댓글을 수정할 권한이 없습니다.");
        }

        if (!comment.getNews().getNewsId().equals(newsId)) {
            throw new CustomException("뉴스 정보가 일치하지 않습니다.");
        }

        comment.setContent(request.getContent());

        Comment updated = commentRepository.save(comment);

        return CommentResponseDTO.builder()
                .replyId(updated.getReplyId())
                .newsId(updated.getNews().getNewsId())
                .content(updated.getContent())
                .createdAt(updated.getCreatedAt())
                .user(CommentResponseDTO.WriterDTO.builder()
                        .userId(updated.getUser().getUserId())
                        .nickname(updated.getUser().getNickname())
                        .profileImage(updated.getUser().getProfileImage())
                        .build())
                .build();
    }

    public void deleteComment(Long newsId, Long replyId, String token) {
        Long userId = jwtProvider.extractUserId(token);

        Comment comment = commentRepository.findByIdWithUserAndNews(replyId)
                .orElseThrow(() -> new CustomException("존재하지 않는 댓글입니다."));

        if (!comment.getUser().getUserId().equals(userId)) {
            throw new CustomException("댓글을 삭제할 권한이 없습니다.");
        }

        if (!comment.getNews().getNewsId().equals(newsId)) {
            throw new CustomException("뉴스 정보가 일치하지 않습니다.");
        }

        commentRepository.delete(comment);
    }

    @Transactional(readOnly = true)
    public List<CommentResponseDTO> getCommentTree(Long newsId) {
        List<Comment> comments = commentRepository.findAllByNewsIdWithUser(newsId); // fetch join
        Map<Long, CommentResponseDTO> map = new HashMap<>();
        List<CommentResponseDTO> roots = new ArrayList<>();

        // 1차로 DTO 변환
        for (Comment comment : comments) {
            CommentResponseDTO dto = CommentResponseDTO.builder()
                    .replyId(comment.getReplyId())
                    .newsId(comment.getNews().getNewsId())
                    .content(comment.getContent())
                    .createdAt(comment.getCreatedAt())
                    .user(CommentResponseDTO.WriterDTO.builder()
                            .userId(comment.getUser().getUserId())
                            .nickname(comment.getUser().getNickname())
                            .profileImage(comment.getUser().getProfileImage())
                            .build())
                    .children(new ArrayList<>()) // children 비워놓기
                    .build();

            map.put(comment.getReplyId(), dto);
        }

        // 계층 구조 구성
        for (Comment comment : comments) {
            if (comment.getParentId() == null) {
                roots.add(map.get(comment.getReplyId()));
            } else {
                CommentResponseDTO parent = map.get(comment.getParentId());
                if (parent != null) {
                    parent.getChildren().add(map.get(comment.getReplyId()));
                }
            }
        }

        return roots;
    }



}
