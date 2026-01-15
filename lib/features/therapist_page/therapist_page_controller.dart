import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/user.dart';

import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;

class PatientRequest {
  final String patientId;
  final UserProfile patient;
  final DateTime requestTime;
  final String? assignedTherapistId;

  PatientRequest({
    required this.patientId,
    required this.patient,
    required this.requestTime,
    this.assignedTherapistId,
  });

  String get requestDate {
    final now = DateTime.now();
    final difference = now.difference(requestTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }
}

class TherapistPageController extends GetxController {
  // Observables
  final selectedTabIndex = 0.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final selectedUserId = ''.obs;

  // Data lists
  final List<UserProfile> allTherapists = [];
  final List<UserProfile> therapyCenters = [];
  final List<UserProfile> allPatients = [];
  final List<PatientRequest> patientRequests = [];

  // Mapping of therapistId -> list of patientIds
  final Map<String, List<String>> therapistPatientMap = {};

  // Getters
  List<UserProfile> get filteredTherapists {
    if (searchQuery.value.isEmpty) {
      return allTherapists;
    }
    return allTherapists.where((therapist) {
      final matchesTherapist = therapist.name
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()) ||
          (therapist.specialization
              ?.toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ??
              false);

      // Also check if any assigned patient matches the search
      final assignedPatients = getAssignedPatientsForTherapist(therapist.id);
      final matchesPatient = assignedPatients.any((patient) =>
      patient.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (patient.specialization
              ?.toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ??
              false));

      return matchesTherapist || matchesPatient;
    }).toList();
  }

  int get totalPatients {
    return therapistPatientMap.values.fold<int>(0, (sum, patientIds) => sum + patientIds.length);
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    isLoading.value = true;

    // Load all therapists
    allTherapists.clear();
    allTherapists.addAll(DummyData.getTherapists());

    // Load therapy centers
    therapyCenters.clear();
    therapyCenters.addAll(DummyData.getTherapyCenters());

    // Load all patients
    allPatients.clear();
    allPatients.addAll(DummyData.getPatients());

    // Initialize therapist-patient assignments
    _initializeAssignments();

    // Load patient requests
    _loadPatientRequests();

    isLoading.value = false;
    update();
  }

  void _initializeAssignments() {
    therapistPatientMap.clear();

    // Assign 3-5 random patients to each therapist
    for (var therapist in allTherapists) {
      final randomPatientCount = 3 + (therapist.id.hashCode % 3); // 3-5 patients
      final assignedPatients = <String>[];

      for (int i = 0; i < randomPatientCount; i++) {
        // Get a patient not already assigned
        final availablePatients = allPatients
            .where((patient) => !_isPatientAssigned(patient.id))
            .toList();

        if (availablePatients.isNotEmpty) {
          final randomIndex = (therapist.id.hashCode + i) % availablePatients.length;
          assignedPatients.add(availablePatients[randomIndex].id);
        }
      }

      therapistPatientMap[therapist.id] = assignedPatients;
    }
  }

  bool _isPatientAssigned(String patientId) {
    return therapistPatientMap.values.any((patientIds) => patientIds.contains(patientId));
  }

  void _loadPatientRequests() {
    patientRequests.clear();

    // Get patients not assigned to any therapist
    final unassignedPatients = allPatients
        .where((patient) => !_isPatientAssigned(patient.id))
        .toList();

    // Create requests for 3 random unassigned patients
    final requestCount = unassignedPatients.length > 3 ? 3 : unassignedPatients.length;

    for (int i = 0; i < requestCount; i++) {
      patientRequests.add(PatientRequest(
        patientId: unassignedPatients[i].id,
        patient: unassignedPatients[i],
        requestTime: DateTime.now().subtract(Duration(hours: i * 6)),
      ));
    }
  }

  List<UserProfile> getAssignedPatientsForTherapist(String therapistId) {
    final patientIds = therapistPatientMap[therapistId] ?? [];
    return patientIds
        .map((id) => allPatients.firstWhere((p) => p.id == id,
        orElse: () => UserProfile(id: '', name: 'Unknown', role: 'patient')))
        .toList();
  }

  UserProfile? getAssignedTherapist(String patientId) {
    for (var entry in therapistPatientMap.entries) {
      if (entry.value.contains(patientId)) {
        return allTherapists.firstWhere((t) => t.id == entry.key);
      }
    }
    return null;
  }

  void assignPatientToTherapist(String patientId, String therapistId) {
    // Remove patient from current assignment if any
    therapistPatientMap.forEach((key, value) {
      value.remove(patientId);
    });

    // Add to new therapist
    if (!therapistPatientMap.containsKey(therapistId)) {
      therapistPatientMap[therapistId] = [];
    }
    therapistPatientMap[therapistId]!.add(patientId);

    // Update request if exists
    final requestIndex = patientRequests.indexWhere((r) => r.patientId == patientId);
    if (requestIndex != -1) {
      patientRequests[requestIndex] = PatientRequest(
        patientId: patientId,
        patient: patientRequests[requestIndex].patient,
        requestTime: patientRequests[requestIndex].requestTime,
        assignedTherapistId: therapistId,
      );
    }

    // Show success message
    final patient = allPatients.firstWhere((p) => p.id == patientId);
    final therapist = allTherapists.firstWhere((t) => t.id == therapistId);

    Get.snackbar(
      'Patient Assigned',
      '${patient.name} has been assigned to ${therapist.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    update();
  }

  void declinePatientRequest(String patientId) {
    final requestIndex = patientRequests.indexWhere((r) => r.patientId == patientId);
    if (requestIndex != -1) {
      final patient = patientRequests[requestIndex].patient;
      patientRequests.removeAt(requestIndex);

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

  void showTherapistSelectionDialog(String patientId) {
    final patient = allPatients.firstWhere((p) => p.id == patientId);

    Get.defaultDialog(
      title: 'Assign ${patient.name} to Therapist',
      content: SizedBox(
        width: 300,
        height: 400,
        child: ListView.builder(
          itemCount: allTherapists.length,
          itemBuilder: (context, index) {
            final therapist = allTherapists[index];
            final assignedCount = therapistPatientMap[therapist.id]?.length ?? 0;

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/${therapist.id.hashCode % 10 + 1}.jpg',
                ),
              ),
              title: Text(therapist.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(therapist.specialization ?? 'No specialization'),
                  Text('$assignedCount patients assigned'),
                ],
              ),
              trailing: assignedCount >= 5
                  ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Full',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                  ),
                ),
              )
                  : null,
              onTap: assignedCount >= 5
                  ? null
                  : () {
                assignPatientToTherapist(patientId, therapist.id);
                Get.back();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void showAssignDialog() {
    Get.defaultDialog(
      title: 'Add New Patient Request',
      content: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            // Search for patients
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search patients...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Implement patient search here
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: allPatients.length,
                itemBuilder: (context, index) {
                  final patient = allPatients[index];
                  final alreadyRequested = patientRequests.any((r) => r.patientId == patient.id);
                  final alreadyAssigned = _isPatientAssigned(patient.id);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(

                            'https://randomuser.me/api/portraits/women/${patient.id.hashCode % 10 + 1}.jpg',
                      ),
                    ),
                    title: Text(patient.name),
                    subtitle: Text(patient.specialization ?? 'Patient'),
                    trailing: alreadyRequested || alreadyAssigned
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: alreadyRequested || alreadyAssigned
                        ? null
                        : () {
                      // Add to requests
                      patientRequests.add(PatientRequest(
                        patientId: patient.id,
                        patient: patient,
                        requestTime: DateTime.now(),
                      ));

                      Get.snackbar(
                        'Request Added',
                        '${patient.name} added to requests',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                      Get.back();
                      update();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void setSelectedUserId(String userId) {
    glbv.selectedUserId = userId;
    // You can store this in global controller
    // Get.find<GlobalController>().selectedUserId = userId;
  }

  void searchTherapists(String query) {
    searchQuery.value = query;
  }
}