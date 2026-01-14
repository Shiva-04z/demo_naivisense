// Add these models to your existing models file

import 'package:flutter/cupertino.dart';

class UserProfile {
  final String id;
  final String name;
  final String role; // 'therapist', 'therapy_center', 'patient'
  final String? specialization;
  final String? location;
  int? experience;
  int followers;
  int posts;
  int? patients;
  int? therapists;
  final bool isVerified;
  bool isFollowing;
  final String? bio;
  final ContactInfo? contactInfo;

  UserProfile({
    required this.id,
    required this.name,
    required this.role,
    this.experience,
    this.specialization,
    this.location,
    this.followers = 0,
    this.posts = 0,
    this.patients,
    this.therapists,
    this.isVerified = false,
    this.isFollowing = false,
    this.bio,
    this.contactInfo,
  });

  UserProfile? copyWith({ bool? isFollowing,  int? followers,int? experience }) {
    return UserProfile(
      id: id,
      role: role,
      name: name,
      bio: bio,
      contactInfo: contactInfo,
      followers: followers?? this.followers,
      isFollowing: isFollowing?? this.isFollowing,
      experience: experience?? this.experience,
      isVerified: isVerified,
      location: location,
      patients: patients,
      posts: posts,
      specialization: specialization,
      therapists: therapists,
    );
  }
}

class ContactInfo {
  final String email;
  final String phone;

  ContactInfo({required this.email, required this.phone});
}

class TimelineEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type;
  final IconData icon;
  final Color color;

  TimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.icon,
    required this.color,
  });
}

class Milestone extends TimelineEvent {
  Milestone({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required IconData icon,
    required Color color,
  }) : super(
         id: id,
         title: title,
         description: description,
         date: date,
         type: 'milestone',
         icon: icon,
         color: color,
       );
}

class Document {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type;
  final IconData icon;
  final Color color;

  Document({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.icon,
    required this.color,
  });
}
