class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String content;
  final int upvotes;
  final int depth;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.content,
    this.upvotes = 0,
    this.depth = 0,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      content: json['content'],
      upvotes: json['upvotes'] ?? 0,
      depth: json['depth'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'upvotes': upvotes,
      'depth': depth,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
