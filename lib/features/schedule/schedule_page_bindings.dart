import 'package:get/get.dart';
import 'package:myapp/features/schedule/schedule_page_controller.dart';

class SchedulePageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>SchedulePageController());
  }
}