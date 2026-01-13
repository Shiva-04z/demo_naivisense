import 'package:get/get.dart';

import '../../models/post.dart';

class HomePageController extends GetxController{


  // Posts list
  RxList<Post> posts = <Post>[].obs;

  // Loading state
  RxBool isLoading = false.obs;

  // Selected filter
  RxString selectedFilter = 'all'.obs;

  // Available filters
  final List<String> filters = [
    'all',
    'following',
    'trending',
    'therapy',
    'nutrition',
    'exercise',
    'mental_health'
  ];

  // Mock users
  final List<Map<String, String>> users = [
    {
      'id': '1',
      'name': 'Dr. Sarah Wilson',
      'role': 'Therapist',
      'profile': 'SW',
    },
    {
      'id': '2',
      'name': 'John Smith',
      'role': 'Patient',
      'profile': 'JS',
    },
    {
      'id': '3',
      'name': 'Harmony Center',
      'role': 'Therapy Center',
      'profile': 'HC',
    },
    {
      'id': '4',
      'name': 'Dr. Michael Chen',
      'role': 'Therapist',
      'profile': 'MC',
    },
    {
      'id': '5',
      'name': 'Emma Johnson',
      'role': 'Patient',
      'profile': 'EJ',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadMockPosts();
  }

  void loadMockPosts() {
    isLoading.value = true;

    // Mock posts data
    posts.assignAll([
      Post(
        id: '1',
        userId: '1',
        userName: 'Dr. Sarah Wilson',
        userProfile: 'SW',
        userRole: 'therapist',
        contentText: 'Just completed an amazing workshop on mindfulness-based stress reduction. The techniques we discussed today can significantly improve quality of life for patients dealing with chronic pain. Remember: "Mindfulness isn\'t difficult, we just need to remember to do it." - Jon Kabat-Zinn',
        images: [
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w-800&auto=format&fit=crop',
        ],
        likes: 245,
        comments: 42,
        shares: 18,
        createdAt: '2 hours ago',
        isLiked: false,
        tags: ['mindfulness', 'therapy', 'mental_health', 'workshop'],
        location: 'Wellness Institute',
      ),
      Post(
        id: '2',
        userId: '2',
        userName: 'John Smith',
        userProfile: 'JS',
        userRole: 'patient',
        contentText: 'Today marks 6 months of my physical therapy journey! From barely walking to completing my first 5k walk. Grateful for my amazing therapist and the supportive community here. Consistency truly is key! 💪 #recoveryjourney #nevergiveup',
        images: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&auto=format&fit=crop',
        ],
        likes: 189,
        comments: 56,
        shares: 12,
        createdAt: '5 hours ago',
        isLiked: true,
        tags: ['recovery', 'physical_therapy', 'fitness', 'achievement'],
        location: 'Central Park',
      ),
      Post(
        id: '3',
        userId: '3',
        userName: 'Harmony Therapy Center',
        userProfile: 'HC',
        userRole: 'therapy_center',
        contentText: 'We\'re excited to announce our new pediatric therapy wing opening next month! State-of-the-art facilities with specialized equipment for children with various needs. Our team has been working tirelessly to create a welcoming and effective environment for young patients.',
        images: [
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&auto=format&fit=crop',
        ],
        likes: 312,
        comments: 23,
        shares: 45,
        createdAt: '1 day ago',
        isLiked: false,
        tags: ['announcement', 'pediatric', 'facilities', 'community'],
      ),
      Post(
        id: '4',
        userId: '4',
        userName: 'Dr. Michael Chen',
        userProfile: 'MC',
        userRole: 'therapist',
        contentText: 'Research update: Recent studies show that combining physical therapy with cognitive behavioral therapy yields 40% better outcomes for chronic back pain patients compared to either treatment alone. Integration is the future of comprehensive care.',
        likes: 167,
        comments: 31,
        shares: 9,
        createdAt: '2 days ago',
        isLiked: false,
        tags: ['research', 'integrated_care', 'chronic_pain', 'science'],
      ),
      Post(
        id: '5',
        userId: '5',
        userName: 'Emma Johnson',
        userProfile: 'EJ',
        userRole: 'patient',
        contentText: 'Sharing my weekly meal plan designed by my nutritionist. Focus on anti-inflammatory foods has made a noticeable difference in my joint pain management. Remember: "Let food be thy medicine" - Hippocrates',
        images: [
          'https://images.unsplash.com/photo-1490818387583-1baba5e638af?w=800&auto=format&fit=crop',
        ],
        likes: 134,
        comments: 28,
        shares: 6,
        createdAt: '3 days ago',
        isLiked: true,
        tags: ['nutrition', 'meal_plan', 'inflammation', 'wellness'],
      ),
      Post(
        id: '6',
        userId: '1',
        userName: 'Dr. Sarah Wilson',
        userProfile: 'SW',
        userRole: 'therapist',
        contentText: 'Quick breathing exercise for stress relief: 4-7-8 technique. Inhale for 4 seconds, hold for 7, exhale for 8. Repeat 4 times. Perfect for pre-appointment nerves or anytime you need to center yourself.',
        likes: 198,
        comments: 19,
        shares: 22,
        createdAt: '4 days ago',
        isLiked: false,
        tags: ['breathing', 'stress_relief', 'quick_tips', 'mindfulness'],
      ),
    ]);

    isLoading.value = false;
  }

  void toggleLike(String postId) {
    final index = posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = posts[index];
      posts[index] = post.copyWith(
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        isLiked: !post.isLiked,
      );
    }
  }

  void addComment(String postId, String comment) {
    final index = posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = posts[index];
      posts[index] = post.copyWith(
        comments: post.comments + 1,
      );
    }
  }

  void sharePost(String postId) {
    final index = posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = posts[index];
      posts[index] = post.copyWith(
        shares: post.shares + 1,
      );
    }
  }

  void filterPosts(String filter) {
    selectedFilter.value = filter;
    // In a real app, you would filter posts from API
    // For now, we'll just show all posts
  }

  Future<void> refreshPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    loadMockPosts();
  }
}