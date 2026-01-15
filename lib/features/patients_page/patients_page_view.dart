import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/patients_page/patients_page_controller.dart';

import '../../models/user.dart';
import '../../navigation/routes_constant.dart';

class PatientsPageView extends GetView<PatientsPageController> {
  const PatientsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Patients'),
          backgroundColor: const Color(0xFF004D4D), // darkTeal
          foregroundColor: const Color(0xFFFAFAFA), // premiumWhite
          bottom: TabBar(
            tabs: const [
              Tab(text: 'My Patients'),
              Tab(text: 'Requests'),
            ],
            indicatorColor: const Color(0xFFD4AF37), // luxuryGold
            labelColor: const Color(0xFFFAFAFA), // premiumWhite
            unselectedLabelColor: Colors.grey[300],
            onTap: (index) {
              controller.selectedTabIndex.value = index;
            },
          ),
        ),
        body: TabBarView(
          children: [
            // My Patients Tab
            _buildMyPatientsTab(),
            // Requests Tab
            _buildRequestsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPatientsTab() {
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: SearchBar(
              hintText: 'Search patients...',
              leading: const Icon(Icons.search, color: Color(0xFF004D4D)), // darkTeal
              elevation: const MaterialStatePropertyAll(0),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              backgroundColor: MaterialStatePropertyAll(
                const Color(0xFFE0F7FA).withOpacity(0.5), // lightTeal
              ),
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              side: MaterialStatePropertyAll(
                BorderSide(
                  color: const Color(0xFF008080).withOpacity(0), // primaryTeal
                ),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
              },
            ),
          ),
        ),

        // Patients count
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: Obx(() => Text(
              '${controller.filteredPatients.length} patients',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF004D4D), // darkTeal
                fontWeight: FontWeight.w500,
              ),
            )),
          ),
        ),

        // Patients grid/list
        Obx(() {
          if (controller.isLoading.value) {
            return const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF008080), // primaryTeal
                ),
              ),
            );
          }

          if (controller.filteredPatients.isEmpty) {
            return SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_off,
                      size: 64,
                      color: const Color(0xFF2C2C2C).withOpacity(0.4), // luxuryGray
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.searchQuery.value.isEmpty
                          ? 'No patients assigned'
                          : 'No patients found',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2C2C2C), // luxuryGray
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 10,
                maxCrossAxisExtent: 200,
                mainAxisExtent: 300
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final patient = controller.filteredPatients[index];
                  return _buildPatientCard(patient);
                },
                childCount: controller.filteredPatients.length,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRequestsTab() {
    return (controller.pendingRequests.isEmpty) ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_disabled,
                size: 64,
                color: Color(0xFF2C2C2C), // luxuryGray
              ),
              SizedBox(height: 16),
              Text(
                'No pending requests',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2C2C2C), // luxuryGray
                ),
              ),
            ],
          ),
        ):
    ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.pendingRequests.length,
        itemBuilder: (context, index) {
          final patient = controller.pendingRequests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: const Color(0xFFFAFAFA), // premiumWhite
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE0F7FA), // lightTeal
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/men/${index + 1}.jpg',
                ),
              ),
              title: Text(
                patient.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C), // luxuryGray
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  if (patient.specialization != null)
                    Text(
                      patient.specialization!,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2C2C2C).withOpacity(0.6), // luxuryGray
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (patient.location != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: const Color(0xFF004D4D), // darkTeal
                        ),
                        const SizedBox(width: 4),
                        Text(
                          patient.location!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF004D4D), // darkTeal
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.declineRequest(patient.id);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD4AF37), // luxuryGold
                            side: const BorderSide(color: Color(0xFFD4AF37)), // luxuryGold
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.acceptRequest(patient.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF008080), // primaryTeal
                            foregroundColor: const Color(0xFFFAFAFA), // premiumWhite
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

  }

  Widget _buildPatientCard(UserProfile patient) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFFAFAFA), // premiumWhite
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          controller.setSelectedUserId(patient.id);
          Get.toNamed(RoutesConstant.patientProfile);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://randomuser.me/api/portraits/women/${patient.hashCode % 10 + 1}.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Online status indicator
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: patient.isOnline ?? false
                              ? const Color(0xFF4CAF50) // Online green
                              : const Color(0xFF9E9E9E), // Offline gray
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFAFAFA), // premiumWhite
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Patient Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        patient.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C), // luxuryGray
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (patient.isVerified)
                        const Icon(
                          Icons.verified,
                          color: Color(0xFFD4AF37), // luxuryGold
                          size: 16,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (patient.specialization != null)
                    Text(
                      patient.specialization!,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF2C2C2C).withOpacity(0.6), // luxuryGray
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (patient.location != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: const Color(0xFF004D4D), // darkTeal
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            patient.location!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF004D4D), // darkTeal
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Last session or next appointment
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA), // lightTeal
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF008080).withOpacity(0.2), // primaryTeal
                      ),
                    ),
                    child: Text(
                      'Last session: 2 days ago',
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF008080), // primaryTeal
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}