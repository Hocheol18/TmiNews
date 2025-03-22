package tmi.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NewsDto {
    private Long newsId;
    private String title;
    private String content;
}
