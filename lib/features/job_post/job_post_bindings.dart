import 'package:get/get.dart';
import 'package:myapp/features/job_post/job_post_controller.dart';

class JobPostBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>JobPostController());
  }

}