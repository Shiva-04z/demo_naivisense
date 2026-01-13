import 'package:get/get.dart';
import 'package:myapp/features/dashboards/therapist_dashboard/therapist_dashboard_binding.dart';
import 'package:myapp/features/dashboards/therapist_dashboard/therapist_dashboard_view.dart';
import 'package:myapp/features/dashboards/therapycenter_dashboard/therapycenter_dashboard_binding.dart';
import 'package:myapp/features/dashboards/therapycenter_dashboard/therapycenter_dashboard_view.dart';
import 'package:myapp/features/home_page/home_page_bindings.dart';
import 'package:myapp/features/login_page/login_page_binidngs.dart';
import 'package:myapp/features/splash_page/splash_page_binidngs.dart';
import 'package:myapp/features/splash_page/splash_page_view.dart';
import 'package:myapp/navigation/routes_constant.dart';

import '../features/dashboards/parent_dashboard/parent_dashboard_bindings.dart';
import '../features/dashboards/parent_dashboard/parent_dashboard_view.dart';
import '../features/home_page/home_page_view.dart';
import '../features/login_page/login_page_view.dart';

List<GetPage> getPages =[
GetPage(name:RoutesConstant.splashPage, page: ()=>SplashPageView(),binding: SplashPageBinidngs()),
GetPage(name:RoutesConstant.loginPage, page: ()=>LoginPageView(),binding: LoginPageBinidngs()),
GetPage(name:RoutesConstant.homePage, page: ()=>HomePageView(),binding: HomePageBindings()),
GetPage(name:RoutesConstant.parentDashboard, page: ()=>ParentDashboardView(),binding: ParentDashboardBindings()),
GetPage(name:RoutesConstant.therapistDashboard, page: ()=>TherapistDashboardView(),binding: TherapistDashboardBinding()),
GetPage(name:RoutesConstant.therapycenterDashboard, page: ()=>TherapycenterDashboardView(),binding: TherapycenterDashboardBinding()),
];