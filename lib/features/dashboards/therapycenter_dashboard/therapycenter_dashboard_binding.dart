import 'package:get/get.dart';
import 'package:myapp/features/dashboards/therapycenter_dashboard/therapycenter_dashboard_controller.dart';

class TherapycenterDashboardBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>TherapycenterDashboardController());
  }
}