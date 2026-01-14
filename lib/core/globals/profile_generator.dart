// Add this class to generate random profile images
import 'dart:ui';

class ProfileImageHelper {
  static final List<String> maleImages = [
    'https://randomuser.me/api/portraits/men/1.jpg',
    'https://randomuser.me/api/portraits/men/2.jpg',
    'https://randomuser.me/api/portraits/men/3.jpg',
    'https://randomuser.me/api/portraits/men/4.jpg',
    'https://randomuser.me/api/portraits/men/5.jpg',
    'https://randomuser.me/api/portraits/men/6.jpg',
    'https://randomuser.me/api/portraits/men/7.jpg',
    'https://randomuser.me/api/portraits/men/8.jpg',
    'https://randomuser.me/api/portraits/men/9.jpg',
    'https://randomuser.me/api/portraits/men/10.jpg',
  ];

  static final List<String> femaleImages = [
    'https://randomuser.me/api/portraits/women/1.jpg',
    'https://randomuser.me/api/portraits/women/2.jpg',
    'https://randomuser.me/api/portraits/women/3.jpg',
    'https://randomuser.me/api/portraits/women/4.jpg',
    'https://randomuser.me/api/portraits/women/5.jpg',
    'https://randomuser.me/api/portraits/women/6.jpg',
    'https://randomuser.me/api/portraits/women/7.jpg',
    'https://randomuser.me/api/portraits/women/8.jpg',
    'https://randomuser.me/api/portraits/women/9.jpg',
    'https://randomuser.me/api/portraits/women/10.jpg',
  ];

  static String getRandomImage(String name, String role) {
    // Generate a consistent hash based on name and role
    int hash = (name + role).hashCode.abs();

    // For therapists: male/female mix
    if (role == 'therapist') {
      List<String> images = hash % 2 == 0 ? maleImages : femaleImages;
      return images[hash % images.length];
    }
    // For therapy centers: more professional/neutral
    else if (role == 'therapy_center') {
      // Use building/center related images
      return 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=200&h=200&fit=crop';
    }
    // For patients: mix of male/female
    else {
      List<String> images = hash % 2 == 0 ? maleImages : femaleImages;
      return images[(hash + 5) % images.length];
    }
  }
}

// Update the _getRoleColor method to use teal shades
Color _getRoleColor(String role) {
  switch (role) {
    case 'therapist':
      return Color(0xFF2DD4BF); // Lightest teal
    case 'therapy_center':
      return Color(0xFF0D9488); // Medium teal
    case 'patient':
      return Color(0xFF134E4A); // Darkest teal
    default:
      return const Color(0xFF0A7C8F);
  }
}