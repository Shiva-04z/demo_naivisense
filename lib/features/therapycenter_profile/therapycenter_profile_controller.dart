import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/user.dart';
import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;
import '../../models/post.dart';
import '../../navigation/routes_constant.dart';

class TherapycenterProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  late String userId;
  late TabController tabController;

  void initTabs({required TickerProvider vsync}) {
    tabController = TabController(
      length: 3,
      vsync: vsync,
      initialIndex: selectedTabIndex,
    );
  }

  final Rx<UserProfile?> _userProfile = Rx<UserProfile?>(null);
  UserProfile? get userProfile => _userProfile.value;

  final RxList<Post> _posts = RxList<Post>([]);
  List<Post> get posts => _posts;

  final RxList<dynamic> _certificates = RxList<dynamic>([]);
  List<dynamic> get certificates => _certificates;

  final RxList<dynamic> _staffMembers = RxList<dynamic>([]);
  List<dynamic> get staffMembers => _staffMembers;

  final RxList<String> _services = RxList<String>([]);
  List<String> get services => _services;

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
      _loadPosts();
      _loadCertificates();
      _loadStaffMembers();
      _loadServices();
      isLoading.value = false;
    });
  }

  void _loadPosts() {
    _posts.value = DummyData.getPostsForUser(userId);
  }

  void _loadCertificates() {
    // Generate dummy certificates for therapy center
    _certificates.value = [
      TherapyCenterCertificate(
        id: 'cert_1',
        title: 'JCI Accreditation',
        issuingOrganization: 'Joint Commission International',
        issueDate: DateTime.now().subtract(Duration(days: 365)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 3)),
        credentialId: 'JCI-ACC-2023-001',
        icon: Icons.medical_services,
        color: Colors.blue,
        type: 'Accreditation',
      ),
      TherapyCenterCertificate(
        id: 'cert_2',
        title: 'Mental Health Facility License',
        issuingOrganization: 'State Health Department',
        issueDate: DateTime.now().subtract(Duration(days: 730)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 2)),
        credentialId: 'MHF-LIC-2022-456',
        icon: Icons.verified,
        color: Colors.green,
        type: 'License',
      ),
      TherapyCenterCertificate(
        id: 'cert_3',
        title: 'ISO 9001:2015 Certified',
        issuingOrganization: 'International Standards Organization',
        issueDate: DateTime.now().subtract(Duration(days: 180)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 3)),
        credentialId: 'ISO-9001-2024',
        icon: Icons.star,
        color: Colors.orange,
        type: 'Quality',
      ),
      TherapyCenterCertificate(
        id: 'cert_4',
        title: 'HIPAA Compliance Certification',
        issuingOrganization: 'Health & Human Services',
        issueDate: DateTime.now().subtract(Duration(days: 90)),
        expiryDate: DateTime.now().add(Duration(days: 365)),
        credentialId: 'HIPAA-COMP-2024',
        icon: Icons.security,
        color: Colors.purple,
        type: 'Compliance',
      ),
      TherapyCenterCertificate(
        id: 'cert_5',
        title: 'Patient Safety Excellence',
        issuingOrganization: 'National Quality Forum',
        issueDate: DateTime.now().subtract(Duration(days: 120)),
        expiryDate: DateTime.now().add(Duration(days: 365 * 2)),
        credentialId: 'PSE-2024-789',
        icon: Icons.health_and_safety,
        color: Colors.teal,
        type: 'Award',
      ),
    ];
  }

  void _loadStaffMembers() {
    // Generate dummy staff members
    _staffMembers.value = DummyData.getTherapists();
  }

  void _loadServices() {
    _services.value = [
      'Individual Therapy',
      'Group Therapy Sessions',
      'Family Counseling',
      'Child & Adolescent Therapy',
      'Trauma Recovery',
      'Anxiety & Depression Treatment',
      'Cognitive Behavioral Therapy',
      'Art & Music Therapy',
      'Online Counseling',
      'Emergency Support',
    ];
  }

  void changeTab(int index) {
    _selectedTabIndex.value = index;
    tabController.animateTo(index);
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

  void contactCenter() {
    Get.snackbar(
      'Contact Request',
      'Your message has been sent to ${userProfile?.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }

  void bookAppointment() {
    Get.toNamed(RoutesConstant.myAi);
  }

  void viewCertificateDetails(TherapyCenterCertificate certificate) {
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: certificate.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  certificate.type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: certificate.color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(height: 12),
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
                            'Verified Accreditation',
                            style: TextStyle(
                              color: certificate.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'This accreditation is recognized nationwide',
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
                  Icon(Icons.download, size: 18,color: Colors.white),
                  SizedBox(width: 6),
                  Text('Download PDF',style: GoogleFonts.poppins(color: Colors.white),),
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
    tabController.dispose();
    super.onClose();
  }
}

class TherapyCenterCertificate {
  final String id;
  final String title;
  final String issuingOrganization;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String credentialId;
  final IconData icon;
  final Color color;
  final String type;

  TherapyCenterCertificate({
    required this.id,
    required this.title,
    required this.issuingOrganization,
    required this.issueDate,
    this.expiryDate,
    required this.credentialId,
    required this.icon,
    required this.color,
    required this.type,
  });
}

