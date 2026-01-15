import 'package:get/get.dart';
import 'conversations_page_controller.dart';
class ConversationsPageBinindgs extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>ConversationsPageController());
  }
}