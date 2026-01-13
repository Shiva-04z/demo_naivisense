import 'package:get/get.dart';
import 'package:myapp/features/splash_page/splash_page_controller.dart';

class SplashPageBinidngs  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>SplashPageController());
  }
}