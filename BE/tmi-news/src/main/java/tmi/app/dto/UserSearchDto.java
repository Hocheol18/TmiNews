package tmi.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class UserSearchDto {
    private Long userId;
    private String nickname;
    private String profileImage;
}
