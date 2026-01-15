import 'package:get/get.dart';
import 'package:myapp/features/message_page/message_page_controller.dart';

class MessagePageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>MessageDetailController());
  }
}