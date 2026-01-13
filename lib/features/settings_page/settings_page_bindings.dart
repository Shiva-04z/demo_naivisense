import 'package:get/get.dart';
import 'package:myapp/features/settings_page/settings_page_controller.dart';

class SettingsPageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>SettingsPageController());
  }
}