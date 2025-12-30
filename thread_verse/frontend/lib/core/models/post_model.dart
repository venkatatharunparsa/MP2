class Post {
  final String id;
  final String title;
  final String? content;
  final String? imageUrl;
  final String authorId;
  final String authorName;
  final String communityId;
  final String communityName;
  final int upvotes;
  final int commentCount;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    this.content,
    this.imageUrl,
    required this.authorId,
    required this.authorName,
    required this.communityId,
    required this.communityName,
    this.upvotes = 0,
    this.commentCount = 0,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      communityId: json['communityId'],
      communityName: json['communityName'],
      upvotes: json['upvotes'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'communityId': communityId,
      'communityName': communityName,
      'upvotes': upvotes,
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
