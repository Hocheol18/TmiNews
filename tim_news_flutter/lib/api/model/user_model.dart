class UserModel {
  final String id;
  final String nickname;
  final String email;

  UserModel({required this.id, required this.email, required this.nickname});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'nickname': nickname};
  }
}
