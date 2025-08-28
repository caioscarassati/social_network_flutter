class PostModel {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String text;
  final String imageUrl;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.text,
    required this.imageUrl,
    required this.createdAt,
  });
}
