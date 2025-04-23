package tmi.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import tmi.app.entity.User;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class FriendDto {

    private Long userId;
    private String nickname;
    private String profileImage;

    // User 객체로부터 DTO 생성
    public FriendDto(User user) {
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.profileImage = user.getProfileImage();
    }
}
