class NewsDetailType {
  final String title;
  final String content;
  final String createdAt;
  final String newsTime;
  final List<Comment> comments;
  final int likes;
  final bool liked;

  NewsDetailType({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.newsTime,
    required this.comments,
    required this.likes,
    required this.liked
  });

  factory NewsDetailType.fromJson(Map<String, dynamic> json) {
    // newsData가 존재하는지 확인
    print(json['data'].keys.toList());
    final commentsData = json['data']['comments'] as List<dynamic>? ?? [];

    return NewsDetailType(
      title: json['data']['title'] ?? '',
      content: json['data']['content'] ?? '',
      createdAt: json['data']['createdAt'] ?? '',
      newsTime: json['data']['newsTime'] ?? '',
      comments: commentsData
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      likes: json['data']['likes'] ?? 0,
      liked: json['data']['liked'] ?? false
    );
  }
}

class Comment {
  final int replyId;
  final int newsId;
  final String content;
  final String createdAt;
  final CommentUser user;
  final List<Comment> children;

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