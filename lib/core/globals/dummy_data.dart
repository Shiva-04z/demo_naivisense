import 'package:flutter/material.dart';
import 'package:myapp/models/job_post.dart';

import '../../models/conversation.dart';
import '../../models/post.dart';
import '../../models/user.dart';

// Dummy data generation
class DummyData {
  // Helper lists for generating random data
  // In your DummyData class, add a method to get current user
  static UserProfile getCurrentUser() {
    return UserProfile(
      id: 'current_user',
      name: 'You',
      role: 'patient', // or whatever your role is
      specialization: 'General Mental Health',
      location: 'New York',
      followers: 150,
      posts: 25,
      isVerified: true,
      isFollowing: false,
      bio: 'Working on personal growth and mental wellness.',
    );
  }

// Update the getMessagesForConversation method to include your messages
  static MessageList getMessagesForConversation(String conversationId) {
    List<Message> messages = [];
    final conversation = getConversationById(conversationId);
    final currentUser = getCurrentUser();

    if (conversation != null) {
      final participants = conversation.participants;
      final now = DateTime.now();

      // Add current user to participants if not already there
      if (!participants.any((user) => user.id == 'current_user')) {
        participants.add(currentUser);
      }

      for (int i = 0; i < 15; i++) {
        final senderIndex = i % participants.length;
        final sender = participants[senderIndex];
        final hoursAgo = (15 - i) * 2;

        // Alternate between user and other participant for more realistic conversation
        final isCurrentUserMessage = i % 2 == 0 || (i % 3 == 0 && i > 5);

        final senderId = isCurrentUserMessage ? 'current_user' : participants.firstWhere(
              (p) => p.id != 'current_user',
          orElse: () => participants[0],
        ).id;

        final senderName = isCurrentUserMessage ? 'You' : participants.firstWhere(
              (p) => p.id != 'current_user',
          orElse: () => participants[0],
        ).name;

        messages.add(Message(
          id: 'msg_${conversationId}_$i',
          conversationId: conversationId,
          senderId: senderId,
          senderName: senderName,
          content: conversationMessages[(i + 5) % conversationMessages.length],
          timestamp: now.subtract(Duration(hours: hoursAgo)),
          isRead: i < 12,
          type: i % 4 == 0 ? MessageType.image :
          i % 5 == 0 ? MessageType.document :
          MessageType.text,
          isSent: true,
          isDelivered: true,
        ));
      }
    }

    return MessageList(
      conversationId: conversationId,
      messages: messages.reversed.toList(), // Most recent last
    );
  }

  // Add to DummyData class (at the end before closing brace)

// Conversation related data
  static final List<String> conversationMessages = [
    'Hello, how are you feeling today?',
    'I\'m doing better, thank you for asking.',
    'That\'s great to hear! Remember to practice the breathing exercises we discussed.',
    'I have been, they really help with my anxiety.',
    'Excellent! Consistency is key. Any specific concerns this week?',
    'I\'ve been having trouble sleeping again.',
    'Let\'s schedule a session to discuss sleep strategies. How about Friday?',
    'Friday works for me. What time?',
    'How does 2 PM sound?',
    'Perfect, I\'ll see you then.',
    'Don\'t forget to fill out your mood tracker this week.',
    'I\'ve been keeping up with it daily.',
    'Great progress! Your commitment is showing results.',
    'Thank you for your support, I really appreciate it.',
    'You\'re doing amazing work. Keep it up!',
    'I have a question about the meditation technique...',
    'Feel free to ask anything, I\'m here to help.',
    'The group session was really helpful last week.',
    'I\'m glad you found it beneficial. We\'ll have another one next month.',
    'Looking forward to it!'
  ];

  static final List<String> conversationTopics = [
    'General Check-in',
    'Anxiety Management',
    'Sleep Issues',
    'Progress Review',
    'Treatment Plan Update',
    'Medication Discussion',
    'Coping Strategies',
    'Emergency Support',
    'Session Scheduling',
    'Resource Sharing'
  ];

// Generate conversations
  static List<Conversation> getConversations() {
    List<Conversation> conversations = [];
    List<UserProfile> allUsers = getAllUsers();

    for (int i = 0; i < 15; i++) {
      UserProfile user1 = allUsers[i];
      UserProfile user2 = allUsers[(i + 5) % allUsers.length];

      // Ensure users are different
      if (user1.id == user2.id) {
        user2 = allUsers[(i + 10) % allUsers.length];
      }

      // Generate random last message time
      final hoursAgo = (i * 3) % 72; // 0 to 71 hours ago
      final String lastSeen;
      if (hoursAgo < 1) {
        lastSeen = 'Just now';
      } else if (hoursAgo < 24) {
        lastSeen = '$hoursAgo h ago';
      } else {
        lastSeen = '${hoursAgo ~/ 24} d ago';
      }

      // Generate random unread count
      final unreadCount = i % 5;

      conversations.add(Conversation(
        id: 'conversation_${i + 1}',
        participantIds: [user1.id, user2.id],
        participants: [user1, user2],
        lastMessage: conversationMessages[i % conversationMessages.length],
        lastMessageTime: lastSeen,
        unreadCount: unreadCount,
        isPinned: i % 4 == 0,
        topic: conversationTopics[i % conversationTopics.length],
        isGroup: i % 6 == 0,
      ));
    }

    return conversations;
  }

// Get conversations for a specific user
  static List<Conversation> getConversationsForUser(String userId) {
    return getConversations().where((conv) =>
        conv.participantIds.contains(userId)
    ).toList();
  }

// Get conversation by ID
  static Conversation? getConversationById(String id) {
    return getConversations().firstWhere((conv) => conv.id == id);
  }




  static final List<String> therapistSpecializations = [
    'Clinical Psychology',
    'Cognitive Behavioral Therapy',
    'Marriage Counseling',
    'Child Psychology',
    'Addiction Counseling',
    'Trauma Therapy',
    'Anxiety Disorders',
    'Depression Treatment',
    'Family Therapy',
    'Art Therapy',
    'Sports Psychology',
    'Eating Disorders',
    'Occupational Therapy',
    'Speech Therapy',
    'Geriatric Psychology'
  ];

  static final List<String> patientConditions = [
    'Anxiety Disorder',
    'Clinical Depression',
    'PTSD',
    'OCD',
    'Bipolar Disorder',
    'ADHD',
    'Autism Spectrum',
    'Eating Disorder',
    'Substance Abuse',
    'Sleep Disorders',
    'Chronic Stress',
    'Social Anxiety',
    'Panic Disorder',
    'Personality Disorder',
    'Grief Counseling'
  ];

  static final List<String> cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
    'Austin',
    'Jacksonville',
    'San Francisco',
    'Columbus',
    'Charlotte',
    'Indianapolis',
    'Seattle',
    'Denver',
    'Boston',
    'Nashville'
  ];

  static final List<String> therapistNames = [
    'Dr. Sarah Johnson',
    'Dr. Michael Chen',
    'Dr. Emily Rodriguez',
    'Dr. James Wilson',
    'Dr. Lisa Thompson',
    'Dr. Robert Miller',
    'Dr. Maria Garcia',
    'Dr. David Brown',
    'Dr. Jennifer Lee',
    'Dr. William Taylor',
    'Dr. Amanda White',
    'Dr. Christopher Moore',
    'Dr. Jessica Clark',
    'Dr. Matthew Davis',
    'Dr. Samantha Martin',
    'Dr. Daniel Anderson',
    'Dr. Olivia Harris',
    'Dr. Kevin Martinez',
    'Dr.Sophia King',
    'Dr. Benjamin Scott'
  ];

  static final List<String> patientNames = [
    'Alex Morgan',
    'Jordan Taylor',
    'Casey Smith',
    'Riley Johnson',
    'Taylor Brown',
    'Morgan Davis',
    'Cameron Wilson',
    'Drew Miller',
    'Jamie Garcia',
    'Quinn Rodriguez',
    'Casey Lee',
    'Jordan White',
    'Alex Taylor',
    'Riley Moore',
    'Morgan Clark',
    'Taylor Davis',
    'Jordan Martin',
    'Alex Anderson',
    'Casey Harris',
    'Riley Martinez'
  ];

  static final List<String> centerNames = [
    'Harmony Mental Wellness Center',
    'Serenity Therapy Clinic',
    'Tranquil Minds Institute',
    'Peaceful Path Counseling',
    'Mindful Healing Center',
    'Balanced Life Therapy',
    'Inner Peace Clinic',
    'Holistic Wellness Institute',
    'Renew Counseling Center',
    'Thrive Mental Health',
    'Wellspring Therapy Center',
    'Nurture Minds Clinic',
    'Bloom Psychology Center',
    'Elevate Wellness Institute',
    'Aspire Counseling Center',
    'Radiant Minds Therapy',
    'Zenith Mental Health',
    'Pinnacle Wellness Center',
    'Horizon Therapy Clinic',
    'Apex Counseling Institute'
  ];

  // Generate 20 therapists
  static List<UserProfile> getTherapists() {
    List<UserProfile> therapists = [];
    for (int i = 0; i < 20; i++) {
      therapists.add(UserProfile(
        id: 'therapist_${i + 1}',
        name: therapistNames[i],
        role: 'therapist',
        specialization: therapistSpecializations[i % therapistSpecializations.length],
        location: cities[i % cities.length],
        followers: 100 + (i * 25),
        posts: 15 + (i * 3),
        patients: 50 + (i * 10),
        isVerified: i % 3 == 0, // Every 3rd therapist is verified
        isFollowing: i % 4 == 0,
        bio: '${therapistSpecializations[i % therapistSpecializations.length]} specialist with ${5 + i} years of experience. Committed to helping clients achieve mental wellness.',
        contactInfo: ContactInfo(
          email: '${therapistNames[i].toLowerCase().replaceAll(' ', '.')}@therapy.com',
          phone: '+1-555-${1000 + i}',
        ),
      ));
    }
    return therapists;
  }

  // Generate 20 patients
  static List<UserProfile> getPatients() {
    List<UserProfile> patients = [];
    for (int i = 0; i < 20; i++) {
      patients.add(UserProfile(
        id: 'patient_${i + 1}',
        name: patientNames[i],
        role: 'patient',
        specialization: patientConditions[i % patientConditions.length],
        location: cities[(i + 5) % cities.length],
        followers: 30 + (i * 10),
        posts: 5 + (i * 2),
        isVerified: i % 5 == 0, // Every 5th patient is verified
        isFollowing: i % 3 == 0,
        bio: 'Working on managing ${patientConditions[i % patientConditions.length].toLowerCase()}. On a journey towards better mental health.',
      ));
    }
    return patients;
  }

  // Generate 20 therapy centers
  static List<UserProfile> getTherapyCenters() {
    List<UserProfile> centers = [];
    for (int i = 0; i < 20; i++) {
      centers.add(UserProfile(
        id: 'center_${i + 1}',
        name: centerNames[i],
        role: 'therapy_center',
        specialization: 'Multi-Specialty Mental Health',
        location: cities[(i + 10) % cities.length],
        followers: 500 + (i * 50),
        posts: 25 + (i * 5),
        therapists: 10 + (i * 2),
        patients: 200 + (i * 30),
        isVerified: i % 2 == 0, // Every other center is verified
        isFollowing: i % 6 == 0,
        bio: 'Comprehensive mental health center offering ${5 + (i % 10)} specialized therapy services. Accredited and patient-focused care.',
        contactInfo: ContactInfo(
          email: 'contact@${centerNames[i].toLowerCase().replaceAll(' ', '')}.com',
          phone: '+1-800-${5000 + i}',
        ),
      ));
    }
    return centers;
  }

  // Generate posts for users
  static List<Post> getPosts() {
    List<Post> posts = [];
    List<UserProfile> allUsers = [...getTherapists(), ...getPatients(), ...getTherapyCenters()];

    final List<String> postContents = [
      'Just completed an amazing workshop on mindfulness meditation!',
      'Mental health is just as important as physical health.',
      'Tips for managing anxiety: practice deep breathing exercises daily.',
      'Had a productive therapy session today.',
      'The power of positive thinking can transform your life.',
      'Self-care isn\'t selfish, it\'s essential.',
      'Join our support group meeting this Friday!',
      'New research shows promising results for CBT in treating depression.',
      'Remember to check in with yourself regularly.',
      'Breaking the stigma around mental health one conversation at a time.',
      'Gratitude journaling has changed my perspective.',
      'The importance of setting healthy boundaries.',
      'Our new therapy program is now accepting applications.',
      'Mental health awareness month events starting soon!',
      'Coping strategies for stressful times.',
      'The healing power of art therapy.',
      'Mindfulness exercises for beginners.',
      'Building resilience through challenging times.',
      'The connection between physical and mental health.',
      'Celebrating small victories in recovery.'
    ];

    final List<String> tags = [
      'MentalHealth',
      'Therapy',
      'Wellness',
      'Mindfulness',
      'SelfCare',
      'CBT',
      'Recovery',
      'Healing',
      'Support',
      'Awareness'
    ];

    int postId = 1;
    for (var user in allUsers) {
      int userPostsCount = user.posts;
      for (int i = 0; i < userPostsCount; i++) {
        posts.add(Post(
          id: 'post_${postId++}',
          userId: user.id,
          userName: user.name,
          userProfile: user.role,
          userRole: user.role,
          contentText: postContents[(postId - 1) % postContents.length],
          images: postId % 3 == 0 ? ['assets/post_${(postId % 5) + 1}.jpg'] : null,
          likes: 10 + (postId * 3) % 100,
          comments: 2 + (postId * 2) % 50,
          shares: 1 + (postId * 1) % 20,
          createdAt: '${(postId % 12) + 1}h ago',
          isLiked: postId % 4 == 0,
          tags: [tags[(postId) % tags.length], tags[(postId + 1) % tags.length]],
          location: user.location,
        ));
      }
    }
    return posts;
  }

  // Generate timeline events for patients
  static List<TimelineEvent> getTimelineEvents(String patientId) {
    return [
      TimelineEvent(
        id: 'event_1',
        title: 'First Therapy Session',
        description: 'Initial consultation and assessment',
        date: DateTime.now().subtract(Duration(days: 90)),
        type: 'milestone',
        icon: Icons.medical_services,
        color: Colors.blue,
      ),
      TimelineEvent(
        id: 'event_2',
        title: 'Treatment Plan Started',
        description: 'Personalized treatment plan implemented',
        date: DateTime.now().subtract(Duration(days: 75)),
        type: 'milestone',
        icon: Icons.assignment,
        color: Colors.green,
      ),
      TimelineEvent(
        id: 'event_3',
        title: 'Progress Review',
        description: 'Monthly progress assessment',
        date: DateTime.now().subtract(Duration(days: 45)),
        type: 'appointment',
        icon: Icons.calendar_today,
        color: Colors.orange,
      ),
      TimelineEvent(
        id: 'event_4',
        title: 'Medication Adjustment',
        description: 'Dosage adjusted based on progress',
        date: DateTime.now().subtract(Duration(days: 30)),
        type: 'treatment',
        icon: Icons.medication,
        color: Colors.purple,
      ),
      TimelineEvent(
        id: 'event_5',
        title: 'Group Therapy Session',
        description: 'Participated in group support session',
        date: DateTime.now().subtract(Duration(days: 15)),
        type: 'session',
        icon: Icons.group,
        color: Colors.teal,
      ),
    ];
  }

  // Generate documents for patients
  static List<Document> getDocuments(String patientId) {
    return [
      Document(
        id: 'doc_1',
        title: 'Initial Assessment Report',
        description: 'Complete psychological evaluation',
        date: DateTime.now().subtract(Duration(days: 85)),
        type: 'report',
        icon: Icons.description,
        color: Colors.blueGrey,
      ),
      Document(
        id: 'doc_2',
        title: 'Treatment Plan',
        description: 'Detailed treatment protocol',
        date: DateTime.now().subtract(Duration(days: 70)),
        type: 'plan',
        icon: Icons.assignment,
        color: Colors.indigo,
      ),
      Document(
        id: 'doc_3',
        title: 'Progress Notes',
        description: 'Session notes and observations',
        date: DateTime.now().subtract(Duration(days: 60)),
        type: 'notes',
        icon: Icons.note,
        color: Colors.brown,
      ),
      Document(
        id: 'doc_4',
        title: 'Lab Results',
        description: 'Blood work and test results',
        date: DateTime.now().subtract(Duration(days: 40)),
        type: 'medical',
        icon: Icons.science,
        color: Colors.red,
      ),
      Document(
        id: 'doc_5',
        title: 'Insurance Forms',
        description: 'Completed insurance documentation',
        date: DateTime.now().subtract(Duration(days: 25)),
        type: 'administrative',
        icon: Icons.request_page,
        color: Colors.green,
      ),
    ];
  }

  // Get all users
  static List<UserProfile> getAllUsers() {
    return [...getTherapists(), ...getPatients(), ...getTherapyCenters()];
  }

  // Get user by ID
  static UserProfile? getUserById(String id) {
    return getAllUsers().firstWhere((user) => user.id == id);
  }

  // Get posts for specific user
  static List<Post> getPostsForUser(String userId) {
    return getPosts().where((post) => post.userId == userId).toList();
  }

  // Get users by role
  static List<UserProfile> getUsersByRole(String role) {
    switch (role) {
      case 'therapist':
        return getTherapists();
      case 'patient':
        return getPatients();
      case 'therapy_center':
        return getTherapyCenters();
      default:
        return [];
    }
  }

  // Search users
  static List<UserProfile> searchUsers(String query) {
    return getAllUsers().where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          (user.specialization?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (user.location?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  // Add these job-related lists to your DummyData class
// Add to your DummyData class
// Therapist job related data
  static final List<String> organizations = [
    'Apollo Rehabilitation Center',
    'Fortis Therapy Services',
    'Max Physical Therapy Clinic',
    'Medanta Rehabilitation Institute',
    'Kokilaben Therapy Center',
    'Manipal Speech & Hearing Center',
    'Narayana Health Rehabilitation',
    'Artemis Therapy Services',
    'Sir HN Reliance Foundation',
    'TATA Memorial Rehabilitation',
    'BLK Therapy Center',
    'Jaslok Therapy Department',
    'Bombay Hospital Rehabilitation',
    'Breach Candy Therapy Center',
    'Lilavati Therapy Services',
    'Ruby Hall Therapy Clinic',
    'Christian Medical College Rehabilitation',
    'Aster DM Healthcare Therapy',
    'Yashoda Therapy Center',
    'KIMS Therapy Services',
    'Care Therapy Institute',
    'Global Therapy Solutions',
    'PhysioOne Center',
    'Rehab Plus Clinic',
    'Therapy Hub India',
    'Mindful Healing Center',
    'Wellness Therapy Clinic',
    'Healing Hands Rehabilitation',
    'Progressive Therapy Center',
    'Holistic Health Therapy',
  ];

  // Indian Cities
  static final List<String> locations = [
    'Mumbai, Maharashtra',
    'Delhi, NCR',
    'Bangalore, Karnataka',
    'Hyderabad, Telangana',
    'Chennai, Tamil Nadu',
    'Kolkata, West Bengal',
    'Pune, Maharashtra',
    'Ahmedabad, Gujarat',
    'Jaipur, Rajasthan',
    'Lucknow, Uttar Pradesh',
    'Chandigarh, Punjab',
    'Bhopal, Madhya Pradesh',
    'Indore, Madhya Pradesh',
    'Coimbatore, Tamil Nadu',
    'Kochi, Kerala',
    'Nagpur, Maharashtra',
    'Visakhapatnam, Andhra Pradesh',
    'Surat, Gujarat',
    'Patna, Bihar',
    'Guwahati, Assam',
  ];

  // Therapy Types
  static final List<String> therapyTypes = [
    'Physical Therapy',
    'Occupational Therapy',
    'Speech Therapy',
    'Psychotherapy',
    'Respiratory Therapy',
    'Music Therapy',
    'Art Therapy',
    'Dance Therapy',
    'Recreational Therapy',
    'Massage Therapy',
    'Aquatic Therapy',
    'Cognitive Behavioral Therapy',
    'Sports Therapy',
    'Pediatric Therapy',
    'Geriatric Therapy',
    'Neurological Therapy',
    'Orthopedic Therapy',
    'Cardiac Rehabilitation',
    'Pulmonary Rehabilitation',
    'Mental Health Therapy',
  ];

  // Job Titles for Therapists
  static final Map<String, List<String>> therapyTitles = {
    'Physical Therapy': [
      'Senior Physical Therapist',
      'Sports Physical Therapist',
      'Orthopedic Physical Therapist',
      'Pediatric Physical Therapist',
      'Neurological Physical Therapist',
      'Geriatric Physical Therapist',
      'Women\'s Health Physical Therapist',
      'Cardiopulmonary Physical Therapist',
      'Manual Therapy Specialist',
      'Vestibular Rehabilitation Therapist',
    ],
    'Occupational Therapy': [
      'Occupational Therapist',
      'Pediatric Occupational Therapist',
      'Hand Therapy Specialist',
      'Neurological Occupational Therapist',
      'Geriatric Occupational Therapist',
      'Mental Health Occupational Therapist',
      'Vocational Rehabilitation Therapist',
      'Sensory Integration Therapist',
      'Ergonomics Consultant',
      'ADL Training Specialist',
    ],
    'Speech Therapy': [
      'Speech Language Pathologist',
      'Pediatric Speech Therapist',
      'Voice Therapy Specialist',
      'Swallowing Therapist (Dysphagia)',
      'Stuttering Therapy Specialist',
      'Audiologist',
      'Communication Disorders Therapist',
      'Accent Modification Therapist',
      'Cognitive Communication Therapist',
      'Augmentative Communication Specialist',
    ],
    'Psychotherapy': [
      'Clinical Psychologist',
      'Counseling Psychologist',
      'Child Psychotherapist',
      'Marriage & Family Therapist',
      'Cognitive Behavioral Therapist',
      'Trauma Therapy Specialist',
      'Addiction Counselor',
      'Art Psychotherapist',
      'Music Psychotherapist',
      'Play Therapy Specialist',
    ],
    'Respiratory Therapy': [
      'Respiratory Therapist',
      'Pulmonary Function Therapist',
      'Sleep Therapy Specialist',
      'Critical Care Respiratory Therapist',
      'Pediatric Respiratory Therapist',
      'Asthma Educator',
      'COPD Rehabilitation Therapist',
      'Ventilator Management Specialist',
      'Home Care Respiratory Therapist',
    ],
    'Music Therapy': [
      'Music Therapist',
      'Neurologic Music Therapist',
      'Pediatric Music Therapist',
      'Geriatric Music Therapist',
      'Mental Health Music Therapist',
      'Rehabilitation Music Therapist',
      'Hospice Music Therapist',
      'Special Education Music Therapist',
    ],
  };

  // Salary Ranges in INR (per month)
  static final Map<String, Map<String, List<int>>> salaryRanges = {
    'Physical Therapy': {
      'Entry Level': [25000, 40000],
      'Mid Level': [40000, 70000],
      'Senior Level': [70000, 120000],
      'Specialist': [80000, 150000],
    },
    'Occupational Therapy': {
      'Entry Level': [22000, 38000],
      'Mid Level': [38000, 65000],
      'Senior Level': [65000, 110000],
      'Specialist': [75000, 140000],
    },
    'Speech Therapy': {
      'Entry Level': [28000, 45000],
      'Mid Level': [45000, 80000],
      'Senior Level': [80000, 130000],
      'Specialist': [90000, 160000],
    },
    'Psychotherapy': {
      'Entry Level': [30000, 50000],
      'Mid Level': [50000, 90000],
      'Senior Level': [90000, 150000],
      'Specialist': [100000, 200000],
    },
    'Respiratory Therapy': {
      'Entry Level': [25000, 42000],
      'Mid Level': [42000, 75000],
      'Senior Level': [75000, 120000],
      'Specialist': [85000, 140000],
    },
    'Music Therapy': {
      'Entry Level': [20000, 35000],
      'Mid Level': [35000, 60000],
      'Senior Level': [60000, 100000],
      'Specialist': [70000, 120000],
    },
  };

  // Qualifications
  static final List<String> qualifications = [
    'BPT (Bachelor of Physiotherapy)',
    'MPT (Master of Physiotherapy)',
    'BOT (Bachelor of Occupational Therapy)',
    'MOT (Master of Occupational Therapy)',
    'BASLP (Bachelor in Audiology & Speech Language Pathology)',
    'MASLP (Master in Audiology & Speech Language Pathology)',
    'MA/MSc Psychology',
    'MPhil Clinical Psychology',
    'Diploma in Respiratory Therapy',
    'Degree in Music Therapy',
    'Certified Art Therapist',
    'Certified Dance Therapist',
    'PG Diploma in Rehabilitation',
    'PhD in relevant field',
    'Certification from Indian Association',
  ];

  // Requirements
  static final Map<String, List<String>> therapyRequirements = {
    'Physical Therapy': [
      'BPT/MPT degree from recognized university',
      'Valid state therapy license',
      '2+ years clinical experience',
      'Knowledge of manual therapy techniques',
      'Experience with therapeutic exercises',
      'Good communication skills',
      'Basic computer skills',
      'CPR certification',
      'Experience with electrotherapy equipment',
    ],
    'Occupational Therapy': [
      'BOT/MOT degree',
      'State registration mandatory',
      'Experience in rehabilitation setting',
      'Knowledge of ADL training',
      'Pediatric experience preferred',
      'Good assessment skills',
      'Patient education skills',
      'Team collaboration ability',
    ],
    'Speech Therapy': [
      'BASLP/MASLP degree',
      'RCI registration required',
      'Experience with speech disorders',
      'Knowledge of assessment tools',
      'Experience with children/adults',
      'Good listening skills',
      'Patience and empathy',
      'Documentation skills',
    ],
    'Psychotherapy': [
      'MA/MSc Psychology',
      'MPhil/PhD preferred',
      'RCI registration mandatory',
      '2+ years therapy experience',
      'Knowledge of therapeutic modalities',
      'Ethical practice knowledge',
      'Confidentiality maintenance',
      'Crisis intervention skills',
    ],
  };

  // Specializations
  static final Map<String, List<String>> specializations = {
    'Physical Therapy': [
      'Sports Injury Rehabilitation',
      'Orthopedic Rehabilitation',
      'Neurological Rehabilitation',
      'Pediatric Physiotherapy',
      'Geriatric Care',
      'Women\'s Health',
      'Cardiac Rehabilitation',
      'Vestibular Rehabilitation',
      'Manual Therapy',
      'Dry Needling',
    ],
    'Occupational Therapy': [
      'Hand Therapy',
      'Pediatric OT',
      'Neurological Rehabilitation',
      'Mental Health',
      'Geriatric Care',
      'Ergonomics',
      'Sensory Integration',
      'Vocational Rehabilitation',
      'ADL Training',
    ],
    'Speech Therapy': [
      'Voice Disorders',
      'Fluency Disorders',
      'Language Disorders',
      'Swallowing Disorders',
      'Hearing Impairment',
      'Autism Spectrum',
      'Accent Modification',
      'Cognitive Communication',
    ],
    'Psychotherapy': [
      'Cognitive Behavioral Therapy',
      'Child Psychology',
      'Trauma Therapy',
      'Marriage Counseling',
      'Addiction Therapy',
      'Anxiety & Depression',
      'Play Therapy',
      'Art Therapy',
    ],
  };

  // Benefits
  static final List<String> benefits = [
    'Health Insurance',
    'Accident Insurance',
    'PF & Gratuity',
    'Paid Time Off',
    'Sick Leave',
    'Maternity/Paternity Leave',
    'Continuing Education Allowance',
    'Conference Sponsorship',
    'Professional Membership Fees',
    'Travel Allowance',
    'Performance Bonus',
    'Flexible Working Hours',
    'Work From Home Options',
    'Child Care Support',
    'Gym Membership',
    'Meal Coupons',
    'Annual Health Checkup',
    'Employee Wellness Programs',
  ];

  // Shifts
  static final List<String> shifts = [
    'Day Shift (9 AM - 5 PM)',
    'Evening Shift (2 PM - 10 PM)',
    'Morning Shift (7 AM - 3 PM)',
    'Flexible Hours',
    'Part-time (4 hours)',
    'Weekends Only',
    'Rotational Shifts',
  ];

  // Descriptions
  static final Map<String, String> therapyDescriptions = {
    'Physical Therapy': 'Join our team of dedicated physical therapists providing comprehensive rehabilitation services. Work with diverse patient populations including sports injuries, neurological conditions, and orthopedic cases.',
    'Occupational Therapy': 'Help patients regain independence in daily activities. Work in a multidisciplinary team focusing on functional rehabilitation and improving quality of life.',
    'Speech Therapy': 'Provide assessment and intervention for communication and swallowing disorders. Work with both pediatric and adult populations in clinical settings.',
    'Psychotherapy': 'Offer evidence-based psychological interventions for various mental health conditions. Work in supportive environment with supervision available.',
    'Respiratory Therapy': 'Specialize in pulmonary rehabilitation and respiratory care. Work with patients with chronic respiratory conditions in hospital and outpatient settings.',
    'Music Therapy': 'Use music interventions to address physical, emotional, cognitive, and social needs of patients. Work in healthcare, educational, and community settings.',
  };

  // Generate Dummy Therapist Jobs
  static List<JobPost> generateTherapistJobs({int count = 50, int appliedCount = 0}) {
    final List<JobPost> jobs = [];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final seed = i + now.millisecondsSinceEpoch;
      final therapyIndex = seed % therapyTypes.length;
      final therapyType = therapyTypes[therapyIndex];

      final titles = therapyTitles[therapyType] ?? ['Therapist'];
      final titleIndex = (seed * 13) % titles.length;
      final title = titles[titleIndex];

      final orgIndex = (seed * 17) % organizations.length;
      final locationIndex = (seed * 19) % locations.length;
      final typeIndex = seed % 4;
      final jobTypes = ['Full-time', 'Part-time', 'Contract', 'Internship'];
      final type = jobTypes[typeIndex];

      // Determine experience level
      String experienceLevel = 'Entry Level';
      if (title.contains('Senior') || title.contains('Specialist')) {
        experienceLevel = 'Senior Level';
      } else if (title.contains('Mid') || seed % 3 == 0) {
        experienceLevel = 'Mid Level';
      }

      // Get salary range
      final salaryMap = salaryRanges[therapyType] ?? salaryRanges['Physical Therapy']!;
      final salaryRangeList = salaryMap[experienceLevel] ?? [25000, 40000];
      final minSalary = salaryRangeList[0];
      final maxSalary = salaryRangeList[1];
      final salary = '${(minSalary / 1000).toStringAsFixed(0)}K - ${(maxSalary / 1000).toStringAsFixed(0)}K';
      final salaryRange = '₹${minSalary.toStringAsFixed(0)} - ₹${maxSalary.toStringAsFixed(0)}';

      // Generate requirements
      final reqList = therapyRequirements[therapyType] ?? therapyRequirements['Physical Therapy']!;
      final requirements = <String>[];
      final reqCount = 3 + (seed % 3);
      for (int j = 0; j < reqCount; j++) {
        requirements.add(reqList[(seed + j) % reqList.length]);
      }

      // Get specialization
      final specList = specializations[therapyType] ?? specializations['Physical Therapy']!;
      final specialization = specList[seed % specList.length];

      // Generate benefits
      final jobBenefits = <String>[];
      final benefitCount = 4 + (seed % 5);
      for (int j = 0; j < benefitCount; j++) {
        jobBenefits.add(benefits[(seed + j) % benefits.length]);
      }

      // Post dates
      final daysAgo = 1 + (seed % 14);
      final postedDate = daysAgo == 1 ? 'Yesterday' : '$daysAgo days ago';
      final deadline = now.add(Duration(days: 7 + (seed % 21))).toString().substring(0, 10);

      // Shift
      final shiftIndex = seed % shifts.length;
      final shift = shifts[shiftIndex];

      // Vacancies
      final vacancies = 1 + (seed % 5);

      // Qualification
      final qualIndex = seed % qualifications.length;
      final qualification = qualifications[qualIndex];

      // Description
      final description = therapyDescriptions[therapyType] ?? 'Therapist position in reputed healthcare organization.';

      // Contact
      final orgName = organizations[orgIndex].toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      final contactEmail = 'careers@${orgName}.com';
      final contactPhone = '+91 ${9000000000 + (seed % 1000000000)}';

      // Urgent, Remote, WalkIn flags
      final isUrgent = seed % 10 == 0; // 10% urgent
      final isRemote = (therapyType == 'Psychotherapy' || therapyType == 'Music Therapy') && seed % 3 == 0;
      final isWalkIn = seed % 15 == 0; // ~7% walk-in

      // Check if this should be applied job
      final isApplied = i < appliedCount;
      final appliedDate = isApplied ? now.subtract(Duration(days: (seed % 7))) : null;

      jobs.add(JobPost(
        id: 'therapy_${therapyType.toLowerCase().replaceAll(' ', '_')}_$i',
        title: title,
        organization: organizations[orgIndex],
        location: locations[locationIndex],
        salary: salary,
        salaryRange: salaryRange,
        type: type,
        postedDate: postedDate,
        deadline: deadline,
        requirements: requirements,
        description: description,
        therapyType: therapyType,
        experience: experienceLevel,
        isApplied: isApplied,
        appliedDate: appliedDate,
        isUrgent: isUrgent,
        isRemote: isRemote,
        isWalkIn: isWalkIn,
        benefits: jobBenefits,
        contactEmail: contactEmail,
        contactPhone: contactPhone,
        minSalary: minSalary,
        maxSalary: maxSalary,
        shift: shift,
        vacancies: vacancies,
        qualification: qualification,
        specialization: specialization,
      ));
    }

    return jobs;
  }

  // Get jobs by therapy type
  static List<JobPost> getJobsByTherapyType(String therapyType, {int count = 10}) {
    return generateTherapistJobs(count: count)
        .where((job) => job.therapyType == therapyType)
        .toList();
  }

  // Get high salary jobs (above 80K)
  static List<JobPost> getHighSalaryJobs({int count = 10}) {
    return generateTherapistJobs(count: count)
        .where((job) => job.averageSalary > 80000)
        .toList();
  }

  // Get remote jobs
  static List<JobPost> getRemoteJobs({int count = 8}) {
    return generateTherapistJobs(count: count)
        .where((job) => job.isRemote)
        .toList();
  }

  // Get urgent jobs
  static List<JobPost> getUrgentJobs({int count = 5}) {
    return generateTherapistJobs(count: count)
        .where((job) => job.isUrgent && !job.isExpired)
        .toList();
  }

  // Get featured jobs (mix of high salary, urgent, and popular therapy types)
  static List<JobPost> getFeaturedJobs({int count = 6}) {
    final allJobs = generateTherapistJobs(count: 20);
    final featured = <JobPost>[];

    // Add urgent jobs
    featured.addAll(allJobs.where((job) => job.isUrgent).take(2));

    // Add high salary jobs
    featured.addAll(allJobs.where((job) => job.averageSalary > 90000).take(2));

    // Add from popular therapy types
    const popularTherapies = ['Physical Therapy', 'Speech Therapy', 'Psychotherapy'];
    for (final therapy in popularTherapies) {
      final therapyJob = allJobs.firstWhere(
            (job) => job.therapyType == therapy && !featured.contains(job),
        orElse: () => allJobs.first,
      );
      if (!featured.contains(therapyJob)) {
        featured.add(therapyJob);
      }
      if (featured.length >= count) break;
    }

    return featured;
  }

  // Get job by ID
  static JobPost? getJobById(String id) {
    try {
      if (id.startsWith('therapy_')) {
        final parts = id.split('_');
        if (parts.length >= 3) {
          final therapyType = parts[1].replaceAll('_', ' ');
          final index = int.tryParse(parts[2]) ?? 0;

          final jobs = generateTherapistJobs(count: index + 1);
          return jobs[index];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get all therapy types
  static List<String> getAllTherapyTypes() {
    return ['All', ...therapyTypes];
  }

  // Get all locations
  static List<String> getAllLocations() {
    return ['All', ...locations.toSet().toList()];
  }

  // Get all experience levels
  static List<String> getAllExperienceLevels() {
    return ['All', 'Entry Level', 'Mid Level', 'Senior Level', 'Specialist'];
  }

  // Get all job types
  static List<String> getAllJobTypes() {
    return ['All', 'Full-time', 'Part-time', 'Contract', 'Internship', 'Freelance'];
  }

  // Get salary ranges for filtering
  static List<Map<String, dynamic>> getSalaryRanges() {
    return [
      {'label': 'All', 'min': 0, 'max': 1000000},
      {'label': 'Under ₹30K', 'min': 0, 'max': 30000},
      {'label': '₹30K - ₹50K', 'min': 30000, 'max': 50000},
      {'label': '₹50K - ₹80K', 'min': 50000, 'max': 80000},
      {'label': '₹80K - ₹1.2L', 'min': 80000, 'max': 120000},
      {'label': 'Above ₹1.2L', 'min': 120000, 'max': 1000000},
    ];
  }

  // Get pre-defined sample jobs for immediate use
  static List<JobPost> getSampleJobs() {
    return [
      JobPost(
        id: 'therapy_pt_001',
        title: 'Senior Physical Therapist',
        organization: 'Apollo Rehabilitation Center',
        location: 'Mumbai, Maharashtra',
        salary: '70K - 1.2L',
        salaryRange: '₹70,000 - ₹1,20,000',
        type: 'Full-time',
        postedDate: '2 days ago',
        deadline: '2024-03-25',
        requirements: [
          'MPT degree from recognized university',
          '5+ years clinical experience',
          'Specialization in sports injury rehabilitation',
          'Valid Maharashtra therapy license',
        ],
        description: 'Lead physical therapist for sports medicine department. Supervise junior therapists and develop rehabilitation protocols.',
        therapyType: 'Physical Therapy',
        experience: 'Senior Level',
        isApplied: false,
        isUrgent: true,
        isRemote: false,
        isWalkIn: false,
        benefits: ['Health Insurance', 'PF', 'Annual Bonus', 'CE Allowance'],
        contactEmail: 'careers@apollorehab.com',
        contactPhone: '+91 9876543210',
        minSalary: 70000,
        maxSalary: 120000,
        shift: 'Day Shift (9 AM - 5 PM)',
        vacancies: 2,
        qualification: 'MPT (Master of Physiotherapy)',
        specialization: 'Sports Injury Rehabilitation',
      ),
      JobPost(
        id: 'therapy_st_002',
        title: 'Speech Language Pathologist',
        organization: 'Manipal Speech & Hearing Center',
        location: 'Bangalore, Karnataka',
        salary: '45K - 80K',
        salaryRange: '₹45,000 - ₹80,000',
        type: 'Full-time',
        postedDate: '1 week ago',
        deadline: '2024-03-30',
        requirements: [
          'BASLP/MASLP degree',
          'RCI registration mandatory',
          'Experience with pediatric cases',
          'Good assessment skills',
        ],
        description: 'Work with children with speech and language disorders. Conduct assessments and provide therapy sessions.',
        therapyType: 'Speech Therapy',
        experience: 'Mid Level',
        isApplied: true,
        appliedDate: DateTime.now().subtract(const Duration(days: 2)),
        isUrgent: false,
        isRemote: false,
        isWalkIn: true,
        benefits: ['Health Insurance', 'PF', 'Paid Leave', 'Training'],
        contactEmail: 'hr@manipalspeech.com',
        contactPhone: '+91 8765432109',
        minSalary: 45000,
        maxSalary: 80000,
        shift: 'Flexible Hours',
        vacancies: 3,
        qualification: 'MASLP (Master in Audiology & Speech Language Pathology)',
        specialization: 'Pediatric Speech Therapy',
      ),
    ];
  }
}


// Usage example:
//
// 1. Get all therapists:
//   List<UserProfile> therapists = DummyData.getTherapists();
//
// 2. Get all patients:
//   List<UserProfile> patients = DummyData.getPatients();
//
// 3. Get all therapy centers:
//   List<UserProfile> centers = DummyData.getTherapyCenters();
//
// 4. Get all users:
//   List<UserProfile> allUsers = DummyData.getAllUsers();
//
// 5. Get posts:
//   List<Post> posts = DummyData.getPosts();
//
// 6. Get user by ID:
//   UserProfile? user = DummyData.getUserById('therapist_1');
//
// 7. Get posts for specific user:
//   List<Post> userPosts = DummyData.getPostsForUser('patient_5');
//
// 8. Get timeline events for patient:
//   List<TimelineEvent> events = DummyData.getTimelineEvents('patient_1');
//
// 9. Get documents for patient:
//   List<Document> docs = DummyData.getDocuments('patient_1');