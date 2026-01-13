class Post {
  String postId;
  String contentText;
  String? contentLink;
  int likes;
  int comments;
  String type;
  String createdAt;

  Post({
    required this.postId,
    required this.type,
    required this.likes,
    required this.comments,
    this.contentLink,
    required this.contentText,
    required this.createdAt
  });
}
