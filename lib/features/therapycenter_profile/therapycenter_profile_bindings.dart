import 'package:get/get.dart';
import 'package:myapp/features/therapycenter_profile/therapycenter_profile_controller.dart';

class TherapycenterProfileBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>TherapycenterProfileController());
  }

}