import 'package:get/get.dart';
import 'package:myapp/features/community_page/community_page_bindings.dart';
import 'package:myapp/features/community_page/community_page_view.dart';
import 'package:myapp/features/conversations_page/conversations_page_binindgs.dart';
import 'package:myapp/features/conversations_page/conversations_page_view.dart';
import 'package:myapp/features/dashboards/therapist_dashboard/therapist_dashboard_binding.dart';
import 'package:myapp/features/dashboards/therapist_dashboard/therapist_dashboard_view.dart';
import 'package:myapp/features/dashboards/therapycenter_dashboard/therapycenter_dashboard_binding.dart';
import 'package:myapp/features/dashboards/therapycenter_dashboard/therapycenter_dashboard_view.dart';
import 'package:myapp/features/home_page/home_page_bindings.dart';
import 'package:myapp/features/job_post/job_post_bindings.dart';
import 'package:myapp/features/job_post/job_post_view.dart';
import 'package:myapp/features/login_page/login_page_binidngs.dart';
import 'package:myapp/features/message_page/message_page_bindings.dart';
import 'package:myapp/features/message_page/message_page_view.dart';
import 'package:myapp/features/my_jobs/my_jobs_bindings.dart';
import 'package:myapp/features/my_jobs/my_jobs_view.dart';
import 'package:myapp/features/patients_page/patients_page_bindings.dart';
import 'package:myapp/features/patients_page/patients_page_view.dart';
import 'package:myapp/features/profile_views/patient_profile_binidngs.dart';
import 'package:myapp/features/profile_views/patient_profile_view.dart';
import 'package:myapp/features/schedule/schedule_page_bindings.dart';
import 'package:myapp/features/schedule/schedule_page_view.dart';
import 'package:myapp/features/settings_page/settings_page_bindings.dart';
import 'package:myapp/features/settings_page/settings_page_view.dart';
import 'package:myapp/features/splash_page/splash_page_binidngs.dart';
import 'package:myapp/features/splash_page/splash_page_view.dart';
import 'package:myapp/features/tasks_page/task_page_bindings.dart';
import 'package:myapp/features/tasks_page/tasks_page_view.dart';
import 'package:myapp/features/therapist_page/therapist_page_bindings.dart';
import 'package:myapp/features/therapist_page/therapists_page_view.dart';
import 'package:myapp/features/therapist_profile/therapist_profile_bindings.dart';
import 'package:myapp/features/therapycenter_profile/therapycenter_profile_bindings.dart';
import 'package:myapp/features/therapycenter_profile/therapycenter_profile_view.dart';
import 'package:myapp/navigation/routes_constant.dart';

import '../features/dashboards/parent_dashboard/parent_dashboard_bindings.dart';
import '../features/dashboards/parent_dashboard/parent_dashboard_view.dart';
import '../features/home_page/home_page_view.dart';
import '../features/login_page/login_page_view.dart';
import '../features/therapist_profile/therapist_profile_view.dart';

List<GetPage> getPages =[
GetPage(name:RoutesConstant.splashPage, page: ()=>SplashPageView(),binding: SplashPageBinidngs()),
GetPage(name:RoutesConstant.loginPage, page: ()=>LoginPageView(),binding: LoginPageBinidngs()),
GetPage(name:RoutesConstant.homePage, page: ()=>HomePageView(),binding: HomePageBindings()),
GetPage(name:RoutesConstant.parentDashboard, page: ()=>ParentDashboardView(),binding: ParentDashboardBindings()),
GetPage(name:RoutesConstant.therapistDashboard, page: ()=>TherapistDashboardView(),binding: TherapistDashboardBinding()),
GetPage(name:RoutesConstant.therapycenterDashboard, page: ()=>TherapycenterDashboardView(),binding: TherapycenterDashboardBinding()),
GetPage(name:RoutesConstant.schedulePage, page: ()=>SchedulePageView(),binding: SchedulePageBindings()),
GetPage(name:RoutesConstant.taskPage, page: ()=>TasksPageView(),binding: TaskPageBindings()),
GetPage(name:RoutesConstant.settingsPage, page: ()=>SettingsPageView(),binding: SettingsPageBindings()),
GetPage(name:RoutesConstant.communityPage, page: ()=>CommunityPageView(),binding: CommunityPageBindings()),
GetPage(name:RoutesConstant.patientProfile, page: ()=>PatientProfileView(),binding: PatientProfileBinidngs()),
GetPage(name:RoutesConstant.therapistProfile, page: ()=>TherapistProfileView(),binding: TherapistProfileBindings()),
GetPage(name:RoutesConstant.centerProfile, page: ()=>TherapycenterProfileView(),binding: TherapycenterProfileBindings()),
GetPage(name:RoutesConstant.conversationPage, page: ()=>ConversationsPageView(),binding: ConversationsPageBinindgs()),
GetPage(name:RoutesConstant.messagesPage, page: ()=>MessageDetailView(),binding: MessagePageBindings()),
GetPage(name:RoutesConstant.patientsPage, page: ()=>PatientsPageView(),binding: PatientsPageBindings()),
GetPage(name:RoutesConstant.therapistPage, page: ()=>TherapistPageView(),binding: TherapistPageBindings()),
  GetPage(name:RoutesConstant.myJobs, page: ()=>MyJobsView(),binding: MyJobsBindings()),
  GetPage(name:RoutesConstant.jobPost, page: ()=>JobPostView(),binding: JobPostBindings()),

];