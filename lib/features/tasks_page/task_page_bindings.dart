import 'package:get/get.dart';
import 'package:myapp/features/tasks_page/task_page_controller.dart';

class TaskPageBindings  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>TaskPageController());
  }

}