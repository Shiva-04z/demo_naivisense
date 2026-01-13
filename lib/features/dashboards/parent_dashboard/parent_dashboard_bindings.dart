import 'package:get/get.dart';
import 'package:myapp/features/dashboards/parent_dashboard/parent_dashboard_controller.dart';


class ParentDashboardBindings  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>ParentDashboardController());
  }
}