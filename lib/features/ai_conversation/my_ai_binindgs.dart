import 'package:get/get.dart';
import 'package:myapp/features/ai_conversation/my_ai_controller.dart';

class MyAiBinindgs extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>MyAiController());
  }
}