package tmi.app.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.List;

@Builder
@Getter
public class CommentResponseDTO {

    private Long replyId;
    private Long newsId;
    private String content;
    private LocalDateTime createdAt;
    private WriterDTO user;
    private List<CommentResponseDTO> children; // 👈 대댓글 리스트 추가

    @Builder
    @Getter
    public static class WriterDTO {
        private Long userId;
        private String nickname;
        private String profileImage;
    }
}
