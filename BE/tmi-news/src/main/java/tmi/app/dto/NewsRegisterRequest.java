package tmi.app.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NewsRegisterRequest {
    private Long newsId;
    private String title;
    private String content;
    private String category;
    private String newsTime;

    // 기본 생성자
    public NewsRegisterRequest() {}

    // 인자 생성자 추가
    public NewsRegisterRequest(Long newsId, String title, String content) {
        this.newsId = newsId;
        this.title = title;
        this.content = content;
    }
}
