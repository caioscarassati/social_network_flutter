import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/features/profile/profile_controller.dart';

class ProfileDialog extends GetView<ProfileController> {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${controller.user.firstName} ${controller.user.lastName}'),
          // Botão de favoritar reativo
          Obx(
                () => IconButton(
              icon: Icon(
                controller.isFavorite.value ? Icons.star : Icons.star_border,
                color: controller.isFavorite.value ? Colors.amber : Colors.grey,
              ),
              onPressed: controller.toggleFavorite,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- ATUALIZADO: Usa as chaves de tradução ---
            _buildDetailRow(Icons.email, 'email_hint'.tr, controller.user.email),
            const Divider(),
            _buildDetailRow(Icons.work, 'profile_job'.tr, controller.jobTitle),
            const Divider(),
            _buildDetailRow(Icons.business, 'profile_area'.tr, controller.department),
            const Divider(),
            _buildDetailRow(Icons.person, 'profile_bio'.tr, controller.biography),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          // --- ATUALIZADO: Usa a chave de tradução ---
          child: Text('profile_close'.tr),
        ),
      ],
    );
  }

  // Widget auxiliar para criar as linhas de detalhe
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Get.theme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(value, style: Get.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
