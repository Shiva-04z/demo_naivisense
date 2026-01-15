import 'package:get/get.dart';
import 'package:myapp/features/my_jobs/my_jobs_controller.dart';

class MyJobsBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>MyJobsController());
  }
}