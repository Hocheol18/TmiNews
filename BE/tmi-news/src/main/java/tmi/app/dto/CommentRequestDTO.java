package tmi.app.dto;

import lombok.Getter;

@Getter
public class CommentRequestDTO {
    private String content;
    private Long parentId; // 대댓글일 경우에만 값이 있음 (null 허용)
}
