import 'package:get/get.dart';
import 'package:myapp/features/therapist_profile/therapist_profile_controller.dart';

class TherapistProfileBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>TherapistProfileController());
  }
}