

class SocialPost {
  final int id;
  final int userId;
  final UserSummary user;
  final String content;
  final String? imageUrl;
  final Map<String, dynamic>? workoutSnapshot;
  final List<PostLike> likes;
  final List<PostComment> comments;
  final DateTime createdAt;
  final bool isLikedByMe; // Computed on frontend or returned by API helper

  SocialPost({
    required this.id,
    required this.userId,
    required this.user,
    required this.content,
    this.imageUrl,
    this.workoutSnapshot,
    this.likes = const [],
    this.comments = const [],
    required this.createdAt,
    this.isLikedByMe = false,
  });

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    // Basic manual parsing to avoid generator dependency for now if preferred, 
    // or we can use json_serializable. Let's do manual for speed.
    return SocialPost(
      id: json['id'],
      userId: json['user_id'],
      user: UserSummary.fromJson(json['user']),
      content: json['content'],
      imageUrl: json['image_url'],
      workoutSnapshot: json['workout_snapshot'],
      likes: (json['likes'] as List?)?.map((e) => PostLike.fromJson(e)).toList() ?? [],
      comments: (json['comments'] as List?)?.map((e) => PostComment.fromJson(e)).toList() ?? [],
      createdAt: DateTime.parse(json['created_at']),
      isLikedByMe: json['is_liked_by_me'] ?? false, 
    );
  }
}

class UserSummary {
  final int id;
  final String name;
  final String? profilePictureUrl;

  UserSummary({required this.id, required this.name, this.profilePictureUrl});

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    // Map backend User model fields
    return UserSummary(
      id: json['id'],
      name: '${json['name'] ?? 'User'}', // Or combine first/last name
      profilePictureUrl: json['profile_picture_url'], // Check backend field name
    );
  }
}

class PostLike {
  final int id;
  final int userId;

  PostLike({required this.id, required this.userId});

  factory PostLike.fromJson(Map<String, dynamic> json) {
    return PostLike(
      id: json['id'],
      userId: json['user_id'],
    );
  }
}

class PostComment {
  final int id;
  final int userId;
  final UserSummary user;
  final String content;
  final DateTime createdAt;

  PostComment({
    required this.id,
    required this.userId,
    required this.user,
    required this.content,
    required this.createdAt,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'],
      userId: json['user_id'],
      user: UserSummary.fromJson(json['user']),
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
