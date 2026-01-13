import 'package:get/get.dart';
import 'package:myapp/features/dashboards/therapist_dashboard/therapist_dashboard_controller.dart';

class TherapistDashboardBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>TherapistDashboardController());
  }
}