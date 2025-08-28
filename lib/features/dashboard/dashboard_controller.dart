import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Controla o índice da aba selecionada
  final selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}