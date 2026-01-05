import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/social_service.dart';
import '../../models/social_models.dart';
import '../../theme/app_colors.dart';
import 'create_post_screen.dart';
import 'package:intl/intl.dart';

class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen> {
  final List<SocialPost> _posts = [];
  bool _isLoading = false;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFeed();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading) {
      _loadFeed();
    }
  }

  Future<void> _loadFeed() async {
    setState(() => _isLoading = true);
    try {
      final newPosts = await SocialService.getFeed(page: _page);
      if (mounted) {
        setState(() {
          _posts.addAll(newPosts);
          _page++;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // ScafoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _posts.clear();
      _page = 1;
    });
    await _loadFeed();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Sosyal Akış', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_rounded),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
              if (result == true) {
                _refreshFeed();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        color: AppColors.primaryColor,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: _posts.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            if (index == _posts.length) {
              return _isLoading 
                ? const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
                : const SizedBox();
            }
            return _PostCard(post: _posts[index]);
          },
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final SocialPost post;

  const _PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              backgroundImage: post.user.profilePictureUrl != null 
                ? NetworkImage(post.user.profilePictureUrl!) 
                : null,
              child: post.user.profilePictureUrl == null 
                ? Text(post.user.name[0], style: const TextStyle(color: Colors.white))
                : null,
            ),
            title: Text(post.user.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text(
              DateFormat('dd MMM HH:mm').format(post.createdAt),
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            trailing: const Icon(Icons.more_horiz, color: Colors.white),
          ),

          // Image
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Image.network(
              'http://localhost:8080${post.imageUrl}', // Use appropriate base URL logic
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
              errorBuilder: (_,__,___) => const SizedBox(height: 200, child: Center(child: Icon(Icons.broken_image, color: Colors.grey))),
            ),

          // Workout Snapshot (if available)
          if (post.workoutSnapshot != null)
            _buildWorkoutSnapshot(context, post.workoutSnapshot!),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _UsageButton(
                  icon: post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                  color: post.isLikedByMe ? Colors.red : Colors.white,
                  count: post.likes.length,
                  onTap: () async {
                    try {
                      await SocialService.likePost(post.id);
                      // In a real app, update local state or re-fetch
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                ),
                const SizedBox(width: 16),
                _UsageButton(
                  icon: Icons.chat_bubble_outline,
                  color: Colors.white,
                  count: post.comments.length,
                  onTap: () {
                    // Show comments bottom sheet
                  },
                ),
                const Spacer(),
                const Icon(Icons.bookmark_border, color: Colors.white),
              ],
            ),
          ),

          // Content/Caption
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(text: '${post.user.name} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: post.content),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWorkoutSnapshot(BuildContext context, Map<String, dynamic> snapshot) {
    final workoutName = snapshot['name'] ?? 'Antrenman';
    final exercises = snapshot['exercises'] as List? ?? [];
    
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             children: [
               const Icon(Icons.fitness_center, size: 16, color: AppColors.primaryColor),
               const SizedBox(width: 8),
               Text(workoutName, style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
             ],
           ),
           const SizedBox(height: 8),
           ...exercises.take(3).map((e) => Padding(
             padding: const EdgeInsets.only(bottom: 4),
             child: Text('• ${e['name']} (${e['sets']} set)', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
           )),
           if (exercises.length > 3)
             Text('+ ${exercises.length - 3} egzersiz daha', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
      ),
    );
  }
}

class _UsageButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const _UsageButton({required this.icon, required this.color, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 6),
          Text('$count', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
