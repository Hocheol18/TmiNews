class UserModel {
  final String nickname;
  final String profile_image_url;

  UserModel({required this.nickname, required this.profile_image_url});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nickname: json['nickname'],
      profile_image_url: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nickname': nickname, 'profile_image_url': profile_image_url};
  }
}
