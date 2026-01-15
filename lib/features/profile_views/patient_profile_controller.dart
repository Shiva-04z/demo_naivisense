import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/user.dart';

import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;

class PatientProfileController extends GetxController  with GetSingleTickerProviderStateMixin{
  late String userId;
  late TabController tabController;

  void initTabs({required TickerProvider vsync}) {
    tabController = TabController(
      length: 2,
      vsync: vsync ,
      initialIndex: selectedTabIndex,
    );
  }

  final Rx<UserProfile?> _userProfile = Rx<UserProfile?>(null);
  UserProfile? get userProfile => _userProfile.value;

  final RxList<dynamic> _timelineEvents = RxList<dynamic>([]);
  List<dynamic> get timelineEvents => _timelineEvents;

  final RxInt _selectedTabIndex = 0.obs;
  int get selectedTabIndex => _selectedTabIndex.value;

  final RxBool isLoading = true.obs;


  @override
  void onInit() {
    super.onInit();
    initTabs(vsync: this);
    loadUserProfile();
  }

  void loadUserProfile() {
    userId = glbv.selectedUserId;
    isLoading.value = true;
    // Simulate API call delay
    Future.delayed(Duration(milliseconds: 500), () {
      _userProfile.value = DummyData.getUserById(userId);
      _timelineEvents.value = DummyData.getTimelineEvents(userId);
      isLoading.value = false;
    });
  }

  void changeTab(int index) {
    _selectedTabIndex.value = index;
  }

  void toggleFollow() {
    if (_userProfile.value != null) {
      final current = _userProfile.value!;
      _userProfile.value = current.copyWith(
        isFollowing: !current.isFollowing,
        followers: current.isFollowing
            ? current.followers - 1
            : current.followers + 1,
      );
    }
  }

  void connectWithUser() {
    Get.snackbar(
      'Connection Request',
      'Connection request sent to ${userProfile?.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }

  void talkToAI() {
    Get.toNamed('/chat', arguments: {'user': userProfile});
  }
}