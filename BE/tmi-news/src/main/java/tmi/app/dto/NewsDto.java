package tmi.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
public class NewsDto {
    private Long newsId;
    private String title;
    private String content;
    private int commentCount;

    public NewsDto(Long newsId, String title, String content) {
        this.newsId = newsId;
        this.title = title;
        this.content = content;
        this.commentCount = 0;
    }

    public NewsDto(Long newsId, String title, String content, int commentCount) {
        this.newsId = newsId;
        this.title = title;
        this.content = content;
        this.commentCount = commentCount;
    }
}
