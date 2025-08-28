import 'package:social_network/app/data/models/post_cache_model.dart';
import 'package:social_network/app/data/models/post_model.dart';
import 'package:social_network/app/data/provider/local_post_cache_provider.dart';
import 'package:social_network/app/data/provider/post_provider.dart';

class PostRepository {
  final PostProvider _postProvider;
  final LocalPostCacheProvider _localPostCacheProvider;

  PostRepository({
    required PostProvider postProvider,
    required LocalPostCacheProvider localPostCacheProvider,
  })  : _postProvider = postProvider,
        _localPostCacheProvider = localPostCacheProvider;

  Future<List<PostCacheModel>> getPosts() async {
    try {
      // Tenta buscar os dados "online"
      final onlinePosts = await _postProvider.getPosts();

      // Converte os modelos para a versão de cache
      final cachePosts = onlinePosts.map((post) => _mapModelToCache(post)).toList();

      // Salva os dados frescos no cache
      await _localPostCacheProvider.savePosts(cachePosts);

      return cachePosts;
    } catch (e) {
      // Se a busca "online" falhar, recorre ao cache
      print("Falha ao buscar posts, carregando do cache: $e");
      return await _localPostCacheProvider.getPosts();
    }
  }

  // Função auxiliar para mapear o modelo de dados para o modelo de cache
  PostCacheModel _mapModelToCache(PostModel post) {
    return PostCacheModel(
      id: post.id,
      authorName: post.authorName,
      authorAvatarUrl: post.authorAvatarUrl,
      text: post.text,
      imageUrl: post.imageUrl,
      createdAt: post.createdAt,
    );
  }
}
