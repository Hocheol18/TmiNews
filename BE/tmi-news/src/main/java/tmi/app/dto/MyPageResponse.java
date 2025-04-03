package tmi.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class MyPageResponse {

    private UserInfo user;
    private List<NewsDto> newsList;

    @Getter
    @Builder
    @AllArgsConstructor
    public static class UserInfo {
        private String nickname;
        private String profileImage;
    }
}
