import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/user.dart';

import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;

class PatientsPageController extends GetxController {
  // Observables
  final selectedTabIndex = 0.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final selectedUserId = ''.obs;

  // Patient lists
  final List<UserProfile> myPatients = [];
  final List<UserProfile> pendingRequests = [];

  // Filtered patients based on search
  List<UserProfile> get filteredPatients {
    if (searchQuery.value.isEmpty) {
      return myPatients;
    }
    return myPatients.where((patient) {
      return patient.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (patient.specialization?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (patient.location?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadPatients();
    loadRequests();
  }

  void loadPatients() {
    isLoading.value = true;

    // Get all patients from DummyData
    final allPatients = DummyData.getPatients();

    // Randomly select 5 patients as "my patients"
    myPatients.clear();

    // Add some fixed patients for consistency
    final List<String> selectedPatientIds = [
      'patient_1', 'patient_3', 'patient_7', 'patient_12', 'patient_15'
    ];

    for (var id in selectedPatientIds) {
      final patient = DummyData.getUserById(id);
      if (patient != null) {
        // Mark these patients as "assigned to me"
        final assignedPatient = patient.copyWith(
          isOnline: id.hashCode % 3 == 0, // Random online status
        );
        myPatients.add(assignedPatient!);
      }
    }

    // Add some additional random patients
    final remainingPatients = allPatients
        .where((p) => !selectedPatientIds.contains(p.id))
        .toList()
        .sublist(0, 3); // Add 3 more random patients

    for (var patient in remainingPatients) {
      final assignedPatient = patient.copyWith(
        isOnline: patient.id.hashCode % 2 == 0,
      );
      myPatients.add(assignedPatient!);
    }

    // Sort by name
    myPatients.sort((a, b) => a.name.compareTo(b.name));

    isLoading.value = false;
    update();
  }

  void loadRequests() {
    // Get all patients
    final allPatients = DummyData.getPatients();

    // Select 2 random patients for pending requests
    pendingRequests.clear();

    // Remove patients that are already in myPatients
    final myPatientIds = myPatients.map((p) => p.id).toList();
    final availablePatients = allPatients
        .where((p) => !myPatientIds.contains(p.id))
        .toList();

    // Take first 2 available patients
    pendingRequests.addAll(availablePatients.take(2));

    update();
  }

  void acceptRequest(String patientId) {
    // Find the patient in pending requests
    final patientIndex = pendingRequests.indexWhere((p) => p.id == patientId);
    if (patientIndex != -1) {
      final patient = pendingRequests.removeAt(patientIndex);

      // Add to my patients
      myPatients.add(patient);
      myPatients.sort((a, b) => a.name.compareTo(b.name));

      // Show success message
      Get.snackbar(
        'Request Accepted',
        '${patient.name} has been added to your patients',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      update();
    }
  }

  void declineRequest(String patientId) {
    final patientIndex = pendingRequests.indexWhere((p) => p.id == patientId);
    if (patientIndex != -1) {
      final patient = pendingRequests.removeAt(patientIndex);

      // Show declined message
      Get.snackbar(
        'Request Declined',
        'You declined ${patient.name}\'s request',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      update();
    }
  }

  void setSelectedUserId(String userId) {
    glbv.selectedUserId = userId;
    // You can also store this in a global controller if needed
    // Get.find<GlobalController>().selectedUserId = userId;
  }

  // Search functionality
  void searchPatients(String query) {
    searchQuery.value = query;
  }
}