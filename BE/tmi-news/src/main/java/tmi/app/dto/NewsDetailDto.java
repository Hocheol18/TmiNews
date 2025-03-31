package tmi.app.dto;


import lombok.Getter;
import lombok.Setter;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;



@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NewsDetailDto {
    private String title;
    private String content;
    private LocalDateTime createdAt;
    private LocalDateTime newsTime;
    private List<CommentDto> comments;  // 댓글 기능 미구현 시, 빈 리스트 반환
    private int likes;                  // 좋아요 기능 미구현 시, 0 반환
}
