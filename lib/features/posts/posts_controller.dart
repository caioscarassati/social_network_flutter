import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:social_network/app/data/models/post_cache_model.dart';
import 'package:social_network/app/data/repository/post_repository.dart';
import 'package:social_network/features/users/users_controller.dart'; // Reutiliza o enum Status

class PostsController extends GetxController {
  final PostRepository _postRepository;
  PostsController({required PostRepository postRepository})
      : _postRepository = postRepository;

  final posts = <PostCacheModel>[].obs;
  final status = Status.loading.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    status.value = Status.loading;
    try {
      final result = await _postRepository.getPosts();
      // Ordena os posts do mais recente para o mais antigo
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      posts.assignAll(result);
      status.value = Status.success;
    } catch (e) {
      debugPrint("Erro ao buscar posts: $e");
      status.value = Status.error;
    }
  }
}
