class NewsDetailType {
  final String title;
  final String content;
  final String createdAt;
  final String newsTime;
  final List<Comment> comments;
  final int likes;

  NewsDetailType({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.newsTime,
    required this.comments,
    required this.likes,
  });

  factory NewsDetailType.fromJson(Map<String, dynamic> json) {
    // newsData가 존재하는지 확인
    print(json['data'].keys.toList());
    final newsData = json['data']['newsData'];
    print(newsData.keys.toList());
    final commentsData = json['data']['comments'] as List<dynamic>? ?? [];
    print(commentsData);

    if (newsData == null) {
      // newsData가 없는 경우 기본값 제공
      return NewsDetailType(
        title: '',
        content: '',
        createdAt: '',
        newsTime: '',
        comments: [],
        likes: 0,
      );
    }

    return NewsDetailType(
      title: newsData['title'] ?? '',
      content: newsData['content'] ?? '',
      createdAt: newsData['createdAt'] ?? '',
      newsTime: newsData['newsTime'] ?? '',
      comments: commentsData
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
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