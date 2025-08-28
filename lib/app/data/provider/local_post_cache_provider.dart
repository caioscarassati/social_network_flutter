import 'package:hive/hive.dart';
import 'package:social_network/app/data/models/post_cache_model.dart';

class LocalPostCacheProvider {
  static const String _postBoxName = 'posts_cache';

  // Salva uma lista de posts, substituindo os dados antigos
  Future<void> savePosts(List<PostCacheModel> posts) async {
    final box = await Hive.openBox<PostCacheModel>(_postBoxName);
    await box.clear();
    for (var post in posts) {
      await box.put(post.id, post);
    }
  }

  // Obtém a lista de posts do cache
  Future<List<PostCacheModel>> getPosts() async {
    final box = await Hive.openBox<PostCacheModel>(_postBoxName);
    return box.values.toList();
  }
}
