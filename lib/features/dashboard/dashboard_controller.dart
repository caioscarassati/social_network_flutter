import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Observável para o índice da página atual
  final currentIndex = 0.obs;

  // Controlador para o PageView
  late final PageController pageController;

  // Lista de títulos para a AppBar, que muda conforme a página
  final List<String> _appBarTitles = [
    'nav_bar_users'.tr,
    'nav_bar_posts'.tr,
  ];

  // Getter para obter o título atual da AppBar
  String get appBarTitle => _appBarTitles[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    // Inicializa o PageController com a página inicial
    pageController = PageController(initialPage: currentIndex.value);
  }

  @override
  void onClose() {
    // Libera os recursos do PageController ao fechar
    pageController.dispose();
    super.onClose();
  }

  /// Altera a página quando um item da navegação é tocado.
  void changePage(int index) {
    // Evita reconstruções desnecessárias se a página for a mesma
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    // Anima a transição para a nova página
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// Atualiza o índice quando a página é alterada pelo deslizar do dedo.
  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
