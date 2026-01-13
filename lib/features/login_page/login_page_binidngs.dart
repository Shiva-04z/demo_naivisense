import 'package:get/get.dart';

import 'login_page_controller.dart';

class LoginPageBinidngs  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>LoginPageController());
  }

}