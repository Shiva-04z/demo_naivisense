import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/user.dart';
import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;

class TherapistProfileController extends GetxController with GetTickerProviderStateMixin {
  late String userId;
  late TabController mainTabController;
  late TabController journeyTabController;

  void initTabs({required TickerProvider vsync}) {
    mainTabController = TabController(
      length: 3,
      vsync: vsync,
      initialIndex: selectedMainTabIndex,
    );

    journeyTabController = TabController(
      length: 2,
      vsync: vsync,
    );
  }

  final Rx<UserProfile?> _userProfile = Rx<UserProfile?>(null);
  UserProfile? get userProfile => _userProfile.value;

  final RxList<dynamic> _timelineEvents = RxList<dynamic>([]);
  List<dynamic> get timelineEvents => _timelineEvents;

  final RxList<dynamic> _certificates = RxList<dynamic>([]);
  List<dynamic> get certificates => _certificates;

  final RxInt _selectedMainTabIndex = 0.obs;
  int get selectedMainTabIndex => _selectedMainTabIndex.value;

  final RxInt _selectedJourneyTabIndex = 0.obs;
  int get selectedJourneyTabIndex => _selectedJourneyTabIndex.value;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initTabs(vsync: this);
    loadUserProfile();

    journeyTabController.addListener(() {
      _selectedJourneyTabIndex.value = journeyTabController.index;
    });
  }

  void loadUserProfile() {
    userId = glbv.selectedUserId;
    isLoading.value = true;
    // Simulate API call delay
    Future.delayed(Duration(milliseconds: 500), () {
      _userProfile.value = DummyData.getUserById(userId);
      _timelineEvents.value = DummyData.getTimelineEvents(userId);
      _loadCertificates();
      isLoading.value = false;
    });
  }

  void _loadCertificates() {
    // Generate dummy certificates
    _certificates.value = [
      Certificate(
        id: 'cert_1',
        title: 'Clinical Psychology Certification',
        issuingOrganization: 'American Psychological Association',
        issueDate: DateTime.now().subtract(Duration(days: 365 * 2)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 3)),
        credentialId: 'APA-CP-2022-12345',
        icon: Icons.verified,
        color: Colors.blue,
      ),
      Certificate(
        id: 'cert_2',
        title: 'Cognitive Behavioral Therapy Specialist',
        issuingOrganization: 'International CBT Association',
        issueDate: DateTime.now().subtract(Duration(days: 365)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 2)),
        credentialId: 'ICBTA-2023-67890',
        icon: Icons.psychology,
        color: Colors.teal,
      ),
      Certificate(
        id: 'cert_3',
        title: 'Trauma-Informed Care Certification',
        issuingOrganization: 'National Trauma Institute',
        issueDate: DateTime.now().subtract(Duration(days: 180)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 4)),
        credentialId: 'NTI-TIC-2024-54321',
        icon: Icons.healing,
        color: Colors.purple,
      ),
      Certificate(
        id: 'cert_4',
        title: 'Licensed Clinical Social Worker',
        issuingOrganization: 'State Licensing Board',
        issueDate: DateTime.now().subtract(Duration(days: 365 * 3)),
        expiryDate: null, // No expiry
        credentialId: 'LCSW-789012',
        icon: Icons.badge,
        color: Colors.orange,
      ),
      Certificate(
        id: 'cert_5',
        title: 'Mindfulness-Based Stress Reduction',
        issuingOrganization: 'Center for Mindfulness',
        issueDate: DateTime.now().subtract(Duration(days: 120)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 2)),
        credentialId: 'MBSR-2024-00123',
        icon: Icons.self_improvement,
        color: Colors.green,
      ),
      Certificate(
        id: 'cert_6',
        title: 'EMDR Therapy Certification',
        issuingOrganization: 'EMDR International Association',
        issueDate: DateTime.now().subtract(Duration(days: 90)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 3)),
        credentialId: 'EMDR-CERT-2024',
        icon: Icons.psychology_alt,
        color: Colors.indigo,
      ),
    ];
  }

  void changeMainTab(int index) {
    _selectedMainTabIndex.value = index;
    mainTabController.animateTo(index);
  }

  void changeJourneyTab(int index) {
    _selectedJourneyTabIndex.value = index;
    journeyTabController.animateTo(index);
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
      'Connection request sent to Dr. ${userProfile?.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }

  void bookAppointment() {
    Get.toNamed('/book-appointment', arguments: {'therapist': userProfile});
  }

  void viewCertificateDetails(Certificate certificate) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: certificate.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(certificate.icon, color: certificate.color, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Certificate Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                certificate.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 12),
              _buildDetailRow('Issued by:', certificate.issuingOrganization),
              _buildDetailRow('Issue Date:', _formatDate(certificate.issueDate)),
              if (certificate.expiryDate != null)
                _buildDetailRow('Expiry Date:', _formatDate(certificate.expiryDate!)),
              _buildDetailRow('Credential ID:', certificate.credentialId),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      certificate.color.withOpacity(0.1),
                      certificate.color.withOpacity(0.05)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: certificate.color.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: certificate.color),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verified Certificate',
                            style: TextStyle(
                              color: certificate.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'This certificate has been verified by our team',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: Text('Close'),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [certificate.color, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Download Started',
                  'Certificate PDF will be downloaded shortly',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: certificate.color,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, size: 18),
                  SizedBox(width: 6),
                  Text('Download PDF'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void onClose() {
    mainTabController.dispose();
    journeyTabController.dispose();
    super.onClose();
  }
}

class Certificate {
  final String id;
  final String title;
  final String issuingOrganization;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String credentialId;
  final IconData icon;
  final Color color;

  Certificate({
    required this.id,
    required this.title,
    required this.issuingOrganization,
    required this.issueDate,
    this.expiryDate,
    required this.credentialId,
    required this.icon,
    required this.color,
  });
}