import 'package:get/get.dart';
import 'package:myapp/features/patients_page/patients_page_controller.dart';

class PatientsPageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>PatientsPageController());
  }

}