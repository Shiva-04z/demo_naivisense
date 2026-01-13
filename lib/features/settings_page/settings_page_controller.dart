import 'package:get/get.dart';

class SettingsPageController extends GetxController {
  // Add controller logic here
  // Example: Observable variables for switches
  final RxBool _isDarkMode = false.obs;
  final RxBool _notificationsEnabled = true.obs;

  bool get isDarkMode => _isDarkMode.value;
  bool get notificationsEnabled => _notificationsEnabled.value;

  void toggleDarkMode(bool value) {
    _isDarkMode.value = value;
    // Add theme switching logic here
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled.value = value;
    // Add notification logic here
  }
}