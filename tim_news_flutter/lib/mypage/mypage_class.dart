class User {
  final String profileImage;
  final String nickname;

  User({
    required this.profileImage,
    required this.nickname
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        profileImage: json['profileImage'] ?? '',
        nickname: json['nickname'] ?? '사용자'
    );
  }
}

class News {
  final int newsId;
  final String title;
  final String content;
  final int commentCount;

  News({
    required this.newsId,
    required this.title,
    required this.content,
    required this.commentCount
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        newsId: json['newsId'] ?? 0,
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        commentCount: json['commentCount'] ?? 0
    );
  }
}

class UserInfo {
  final User user;
  final int friendCount;
   final List<News> newsList;

  UserInfo({
    required this.user,
    required this.friendCount,
    required this.newsList
  });

  // JSON 변환을 위한 팩토리 생성자 추가
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      // API의 실제 키 이름에 맞게 수정
        user: User.fromJson(json['user'] ?? {}),
        friendCount: json['friendCount'] ?? 0,
        // API의 실제 키 이름에 맞게 수정
        newsList: (json['newsList'] as List<dynamic>?)
            ?.map((newsJson) => News.fromJson(newsJson))
            .toList() ?? []
    );
  }
}

class FriendInfo {
  final int userId;
  final String nickname;
  final String profileImage;

  FriendInfo({
    required this.userId,
    required this.nickname,
    required this.profileImage
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) {
    return FriendInfo(
        userId: json['userId'] ?? 0,
        nickname: json['nickname'] ?? '',
        profileImage: json['profileImage'] ?? ''
    );
  }
}

class Alarm {
  final int id;
  final String message;
  final String type;
  final int targetId;
  final int targetUserId;
  final String createdAt;
  final bool read;

  Alarm({
    required this.id,
    required this.message,
    required this.type,
    required this.targetId,
    required this.targetUserId,
    required this.createdAt,
    required this.read,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      targetId: json['targetId'] ?? 0,
      targetUserId: json['targetUserId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      read: json['read'] ?? false,
    );
  }
}