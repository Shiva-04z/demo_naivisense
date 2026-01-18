import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/globals/global_variables.dart' as glbv;

class SettingsPageController extends GetxController {
  // Add controller logic here
  // Example: Observable variables for switches
  final RxBool _isDarkMode = false.obs;
  final RxBool _notificationsEnabled = true.obs;

  TextEditingController linkcontroller = TextEditingController();



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

  Future<void> saveUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("apiurl", url+".ngrok-free.app");
    glbv.apiUrl = url+".ngrok-free.app";
    Get.snackbar("Saved", "Saved Successfully",backgroundColor: Colors.teal.shade900,colorText: Colors.white);

  }
}