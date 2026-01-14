import 'package:get/get.dart';
import 'package:myapp/features/profile_views/patient_profile_controller.dart';

class PatientProfileBinidngs extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>PatientProfileController());
  }
}