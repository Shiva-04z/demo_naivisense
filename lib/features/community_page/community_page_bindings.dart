import 'package:get/get.dart';
import 'package:myapp/features/community_page/community_page_controller.dart';

class CommunityPageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> CommunityPageController());
  }
}