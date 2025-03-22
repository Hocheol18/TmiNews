package tmi.app.dto;

public class KakaoUserInfoResponse {
    private String id;
    private String nickname;
    private String profileImageUrl;

    public KakaoUserInfoResponse() {}

    public KakaoUserInfoResponse(String id, String nickname, String profileImageUrl) {
        this.id = id;
        this.nickname = nickname;
        this.profileImageUrl = profileImageUrl;
    }

    // ✅ Getter & Setter 추가
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }

    @Override
    public String toString() {
        return "KakaoUserInfoResponse{" +
                "id='" + id + '\'' +
                ", nickname='" + nickname + '\'' +
                ", profileImageUrl='" + profileImageUrl + '\'' +
                '}';
    }
}
