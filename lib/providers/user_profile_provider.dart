import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

// User Profile Provider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null) {
    _loadUserProfile();
  }

  static const _uuid = Uuid();

  void _loadUserProfile() {
    final box = DatabaseService.userProfileBox;
    if (box.isNotEmpty) {
      state = box.values.first;
    }
  }

  Future<void> createProfile({
    required String name,
    required int age,
    required String gender,
    required double heightCm,
    required String activityLevel,
    required String goal,
  }) async {
    final profile = UserProfile(
      id: _uuid.v4(),
      name: name,
      age: age,
      gender: gender,
      heightCm: heightCm,
      activityLevel: activityLevel,
      goal: goal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await DatabaseService.userProfileBox.clear();
    await DatabaseService.userProfileBox.add(profile);
    state = profile;
  }

  Future<void> updateProfile({
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    String? activityLevel,
    String? goal,
  }) async {
    if (state == null) return;

    final updatedProfile = state!.copyWith(
      name: name,
      age: age,
      gender: gender,
      heightCm: heightCm,
      activityLevel: activityLevel,
      goal: goal,
    );

    await DatabaseService.userProfileBox.clear();
    await DatabaseService.userProfileBox.add(updatedProfile);
    state = updatedProfile;
  }

  void refresh() {
    _loadUserProfile();
  }
}
