import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;
import '../../models/user.dart';


class CommunityPageController extends GetxController {
  // Assuming you have a global controller with user role
   // Adjust based on your structure

  final RxString searchQuery = ''.obs;
  final RxList<UserProfile> filteredUsers = <UserProfile>[].obs;
  final RxList<String> followingUsers = <String>[].obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data
    searchUsers('');
  }

  void searchUsers(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredUsers.clear();
    } else {
      List<UserProfile> allUsers = [];

      // Always show therapists and centers
      allUsers.addAll(DummyData.getTherapists());
      allUsers.addAll(DummyData.getTherapyCenters());

      // Only show patients if current user is a patient
      if (glbv.role == "patient") {
        allUsers.addAll(DummyData.getPatients());
      }

      // Filter users based on search query
      filteredUsers.assignAll(allUsers.where((user) {
        final nameMatch = user.name.toLowerCase().contains(query.toLowerCase());
        final specializationMatch = user.specialization?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final locationMatch = user.location?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final roleMatch = user.role.toLowerCase().contains(query.toLowerCase());

        return nameMatch || specializationMatch || locationMatch || roleMatch;
      }).toList());
    }
  }

  void toggleFollow(String userId) {
    if (followingUsers.contains(userId)) {
      followingUsers.remove(userId);
    } else {
      followingUsers.add(userId);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}