package tmi.app.dto;


import lombok.Getter;
import lombok.Setter;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;



@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NewsDetailDto {
    private NewsData newsData;
    private List<CommentResponseDTO> comments;
    private int likes;

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class NewsData {
        private String title;
        private String content;
        private LocalDateTime createdAt;
        private LocalDateTime newsTime;
    }
}
