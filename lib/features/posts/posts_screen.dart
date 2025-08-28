import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:social_network/app/data/models/post_cache_model.dart';
import 'package:social_network/features/posts/posts_controller.dart';
import 'package:social_network/features/users/users_controller.dart'; // Reutiliza o enum Status

class PostsScreen extends GetView<PostsController> {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('posts_title'.tr),
      ),
      body: Obx(
            () {
          switch (controller.status.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              return Center(child: Text('error_generic'.tr));
            case Status.success:
              return RefreshIndicator(
                onRefresh: controller.fetchPosts,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];
                    return PostCard(post: post);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

// Widget para exibir um card de postagem
class PostCard extends StatelessWidget {
  final PostCacheModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do post
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(post.authorAvatarUrl),
                ),
                const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName, style: Get.textTheme.titleMedium),
                    Text(
                      DateFormat.yMMMd(Get.locale.toString()).format(post.createdAt),
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Imagem do post
          CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
            placeholder: (context, url) => Container(
              height: 250,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          // Texto do post
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(post.text, style: Get.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
