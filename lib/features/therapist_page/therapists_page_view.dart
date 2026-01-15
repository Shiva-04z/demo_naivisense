import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/therapist_page/therapist_page_controller.dart';

import '../../models/user.dart';
import '../../navigation/routes_constant.dart';

class TherapistPageView extends GetView<TherapistPageController> {
  const TherapistPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Therapists & Patients'),
          backgroundColor: const Color(0xFF004D4D), // darkTeal
          foregroundColor: const Color(0xFFFAFAFA), // premiumWhite
          bottom: TabBar(
            tabs: const [
              Tab(text: 'All Therapists'),
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
            // All Therapists Tab with their patients
            _buildTherapistsTab(),
            // Requests Tab
            _buildRequestsTab(),
          ],
        ),
        floatingActionButton: Obx(() {
          if (controller.selectedTabIndex.value == 1) {
            return FloatingActionButton(
              onPressed: () => controller.showAssignDialog(),
              backgroundColor: const Color(0xFF008080), // primaryTeal
              foregroundColor: const Color(0xFFFAFAFA), // premiumWhite
              child: const Icon(Icons.person_add_alt_1),
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildTherapistsTab() {
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: SearchBar(
              hintText: 'Search therapists or patients...',
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

        // Stats
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    'Therapists',
                    controller.allTherapists.length.toString(),
                    Icons.psychology,
                    const Color(0xFF008080), // primaryTeal
                  ),
                  _buildStatCard(
                    'Patients',
                    controller.totalPatients.toString(),
                    Icons.group,
                    const Color(0xFF4DB6AC), // accentTeal
                  ),
                ],
              ),
            ),
          ),
        ),

        // Therapists List
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

          if (controller.filteredTherapists.isEmpty) {
            return SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.spa,
                      size: 64,
                      color: const Color(0xFF2C2C2C).withOpacity(0.4), // luxuryGray
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.searchQuery.value.isEmpty
                          ? 'No therapists found'
                          : 'No results found',
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
            sliver: SliverList.builder(
              itemCount: controller.filteredTherapists.length,
              itemBuilder: (context, index) {
                final therapist = controller.filteredTherapists[index];
                final assignedPatients = controller
                    .getAssignedPatientsForTherapist(therapist.id);
                return _buildTherapistExpansionTile(therapist, assignedPatients);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white, // premiumWhite
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C), // luxuryGray
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF004D4D), // darkTeal
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTherapistExpansionTile(
      UserProfile therapist,
      List<UserProfile> patients,
      ) {
    return Card(
      color: Colors.white,
      elevation: 10,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data:  Theme.of(Get.context!).copyWith(
            expansionTileTheme: const ExpansionTileThemeData(
              shape: Border(),
            )
          ),
          child: ExpansionTile(
            collapsedShape:ContinuousRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)) ,
            shape: ContinuousRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE0F7FA), // lightTeal
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/${therapist.id.hashCode % 10 + 1}.jpg',
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    therapist.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C), // luxuryGray
                    ),
                  ),
                ),
                if (therapist.isVerified)
                  const Icon(Icons.verified, color: Color(0xFFD4AF37), size: 16), // luxuryGold
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                if (therapist.specialization != null)
                  Text(
                    therapist.specialization!,
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF2C2C2C).withOpacity(0.6), // luxuryGray
                    ),
                  ),
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      size: 12,
                      color: const Color(0xFF004D4D), // darkTeal
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${patients.length} patients',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF004D4D), // darkTeal
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.person, color: Color(0xFF008080)), // primaryTeal
              onPressed: () {
                controller.setSelectedUserId(therapist.id);
                Get.toNamed(RoutesConstant.therapistProfile);
              },
              tooltip: 'View Therapist Profile',
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            collapsedBackgroundColor: Colors.white, // premiumWhite
            backgroundColor: Colors.teal.shade50.withOpacity(0.1), // premiumWhite
            iconColor: const Color(0xFF008080), // primaryTeal
            collapsedIconColor: const Color(0xFF008080), // primaryTeal
            children: [
              if (patients.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No patients assigned',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2C2C2C), // luxuryGray
                    ),
                  ),
                )
              else
                ...patients.map((patient) => _buildPatientListItem(patient)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientListItem(UserProfile patient) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFFE0F7FA), // lightTeal
        backgroundImage: NetworkImage(
          'https://randomuser.me/api/portraits/women/${patient.id.hashCode % 10 + 1}.jpg',
        ),
      ),
      title: Text(
        patient.name,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF2C2C2C), // luxuryGray
        ),
      ),
      subtitle: patient.specialization != null
          ? Text(
        patient.specialization!,
        style: TextStyle(
          fontSize: 12,
          color: const Color(0xFF2C2C2C).withOpacity(0.6), // luxuryGray
        ),
      )
          : null,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA), // lightTeal
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)), // primaryTeal
        ),
        child: Text(
          patient.location?.substring(0, 3) ?? 'N/A',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF004D4D), // darkTeal
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        controller.setSelectedUserId(patient.id);
        Get.toNamed(RoutesConstant.patientProfile);
      },
    );
  }

  Widget _buildRequestsTab() {
   return (controller.patientRequests.isEmpty) ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                size: 64,
                color: Color(0xFF2C2C2C), // luxuryGray
              ),
              SizedBox(height: 16),
              Text(
                'No patient requests',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2C2C2C), // luxuryGray
                ),
              ),
            ],
          ))
       : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.patientRequests.length,
        itemBuilder: (context, index) {
          final request = controller.patientRequests[index];
          final assignedTherapist = controller.getAssignedTherapist(request.patientId);

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
                request.patient.name,
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
                  if (request.patient.specialization != null)
                    Text(
                      request.patient.specialization!,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2C2C2C).withOpacity(0.6), // luxuryGray
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Requested: ${request.requestDate}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF004D4D), // darkTeal
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (assignedTherapist != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA), // lightTeal
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)), // primaryTeal
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.psychology, size: 16, color: Color(0xFF008080)), // primaryTeal
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Assigned to: ${assignedTherapist.name}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF004D4D), // darkTeal
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1), // luxuryGold
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Not assigned to any therapist',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFFD4AF37), // luxuryGold
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: PopupMenuButton(
                color: const Color(0xFFFAFAFA), // premiumWhite
                itemBuilder: (context) => [
                  if (assignedTherapist == null)
                    PopupMenuItem(
                      value: 'assign',
                      child: Row(
                        children: [
                          const Icon(Icons.person_add, size: 18, color: Color(0xFF008080)), // primaryTeal
                          const SizedBox(width: 8),
                          Text(
                            'Assign to Therapist',
                            style: TextStyle(
                              color: const Color(0xFF2C2C2C), // luxuryGray
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (assignedTherapist != null)
                    PopupMenuItem(
                      value: 'reassign',
                      child: Row(
                        children: [
                          const Icon(Icons.swap_horiz, size: 18, color: Color(0xFF008080)), // primaryTeal
                          const SizedBox(width: 8),
                          Text(
                            'Reassign',
                            style: TextStyle(
                              color: const Color(0xFF2C2C2C), // luxuryGray
                            ),
                          ),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(Icons.visibility, size: 18, color: Color(0xFF008080)), // primaryTeal
                        const SizedBox(width: 8),
                        Text(
                          'View Details',
                          style: TextStyle(
                            color: const Color(0xFF2C2C2C), // luxuryGray
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'decline',
                    child: Row(
                      children: [
                        const Icon(Icons.cancel_outlined, size: 18, color: Color(0xFFD4AF37)), // luxuryGold
                        const SizedBox(width: 8),
                        Text(
                          'Decline Request',
                          style: const TextStyle(color: Color(0xFFD4AF37)), // luxuryGold
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'assign' || value == 'reassign') {
                    controller.showTherapistSelectionDialog(request.patientId);
                  } else if (value == 'view') {
                    controller.setSelectedUserId(request.patientId);
                    Get.toNamed(RoutesConstant.patientProfile);
                  } else if (value == 'decline') {
                    controller.declinePatientRequest(request.patientId);
                  }
                },
              ),
            ),
          );
        },
      );
  }
}