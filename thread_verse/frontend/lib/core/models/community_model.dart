class Community {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final String? bannerUrl;
  final int memberCount;
  final DateTime createdAt;

  Community({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.bannerUrl,
    this.memberCount = 0,
    required this.createdAt,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      bannerUrl: json['bannerUrl'],
      memberCount: json['memberCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'bannerUrl': bannerUrl,
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
