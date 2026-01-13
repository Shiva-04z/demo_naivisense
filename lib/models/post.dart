class Post {
  final String id;
  final String userId;
  final String userName;
  final String userProfile;
  final String userRole;
  final String contentText;
  final List<String>? images;
  final int likes;
  final int comments;
  final int shares;
  final String createdAt;
  final bool isLiked;
  final List<String>? tags;
  final String? location;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.userRole,
    required this.contentText,
    this.images,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.createdAt,
    this.isLiked = false,
    this.tags,
    this.location,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfile,
    String? userRole,
    String? contentText,
    List<String>? images,
    int? likes,
    int? comments,
    int? shares,
    String? createdAt,
    bool? isLiked,
    List<String>? tags,
    String? location,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfile: userProfile ?? this.userProfile,
      userRole: userRole ?? this.userRole,
      contentText: contentText ?? this.contentText,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      tags: tags ?? this.tags,
      location: location ?? this.location,
    );
  }
}