import 'package:flutter/material.dart';

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