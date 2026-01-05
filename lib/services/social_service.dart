import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/social_models.dart';

class SocialService {
  // Use 10.0.2.2 for Android emulator, localhost for Linux/Web
  static String get _baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/social';
    }
    return 'http://localhost:8080/api/social';
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await AuthService.getToken();
    return {
      ..._headers,
      'Authorization': 'Bearer $token',
    };
  }

  // Get Feed
  static Future<List<SocialPost>> getFeed({int page = 1, int limit = 10}) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/feed?page=$page&limit=$limit'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List postsJson = data['data'];
      return postsJson.map((json) => SocialPost.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feed: ${response.statusCode}');
    }
  }

  // Create Post
  static Future<SocialPost> createPost({
    required String content,
    String? imagePath,
    Map<String, dynamic>? workoutSnapshot,
  }) async {
    final token = await AuthService.getToken();
    
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/posts'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['content'] = content;
    
    if (workoutSnapshot != null) {
      request.fields['workout_snapshot'] = jsonEncode(workoutSnapshot);
    }

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return SocialPost.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to create post: ${response.statusCode} $responseBody');
    }
  }

  // Like Post
  static Future<bool> likePost(int postId) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/posts/$postId/like'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['liked'] ?? false;
    } else {
      throw Exception('Failed to like post');
    }
  }

  // Comment on Post
  static Future<PostComment> createComment(int postId, String content) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/posts/$postId/comments'),
      headers: headers,
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 201) {
      return PostComment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post comment');
    }
  }
}
