class NewsDetail {
  final String title;
  final String content;
  final String createdAt;
  final String newsTime;
  final List<Comment> comments;
  final int likes;

  NewsDetail({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.newsTime,
    required this.comments,
    required this.likes,
  });

  factory NewsDetail.fromJson(Map<String, dynamic> json) {
    return NewsDetail(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      newsTime: json['newsTime'] ?? '',
      comments: (json['comments'] as List<dynamic>?)
          ?.map((commentJson) => Comment.fromJson(commentJson))
          .toList() ?? [],
      likes: json['likes'] ?? 0,
    );
  }
}

class Comment {
  final int replyId;
  final int newsId;
  final String content;
  final String createdAt;
  final CommentUser user;
  final List<Comment> children;  // 재귀적 구조: Comment 안에 Comment 리스트가 있음

  Comment({
    required this.replyId,
    required this.newsId,
    required this.content,
    required this.createdAt,
    required this.user,
    required this.children,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      replyId: json['replyId'] ?? 0,
      newsId: json['newsId'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
      children: (json['children'] as List<dynamic>?)
          ?.map((childJson) => Comment.fromJson(childJson))
          .toList() ?? [],
    );
  }
}

class CommentUser {
  final int userId;
  final String nickname;
  final String profileImage;

  CommentUser({
    required this.userId,
    required this.nickname,
    required this.profileImage,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      userId: json['userId'] ?? 0,
      nickname: json['nickname'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}