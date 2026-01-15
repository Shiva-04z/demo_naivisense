import 'package:get/get.dart';
import 'package:myapp/features/therapist_page/therapist_page_controller.dart';

class TherapistPageBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>TherapistPageController());
  }
}
