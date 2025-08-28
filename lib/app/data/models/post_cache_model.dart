import 'package:hive/hive.dart';

part 'post_cache_model.g.dart'; // Ficheiro a ser gerado pelo build_runner

@HiveType(typeId: 2) // O typeId deve ser único (0=User, 1=UserCache)
class PostCacheModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String authorName;

  @HiveField(2)
  late String authorAvatarUrl;

  @HiveField(3)
  late String text;

  @HiveField(4)
  late String imageUrl;

  @HiveField(5)
  late DateTime createdAt;

  PostCacheModel({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.text,
    required this.imageUrl,
    required this.createdAt,
  });
}
