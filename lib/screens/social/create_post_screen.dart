import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/social_service.dart';
import '../../models/workout.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_colors.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  File? _selectedImage;
  Workout? _selectedWorkout;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _selectWorkout() {
    // Show workout history bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBackground,
      builder: (context) {
        // Fetch last 10 workouts from provider
        final workouts = ref.read(workoutsProvider).reversed.take(10).toList();
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final w = workouts[index];
            return ListTile(
              title: Text(w.exerciseName, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${w.workoutDate.day}/${w.workoutDate.month}/${w.workoutDate.year} - ${w.durationMinutes} dk', style: const TextStyle(color: Colors.grey)),
              onTap: () {
                setState(() => _selectedWorkout = w);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _sharePost() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen bir fotoğraf seçin')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      Map<String, dynamic>? workoutSnapshot;
      if (_selectedWorkout != null) {
        workoutSnapshot = {
          'name': _selectedWorkout!.exerciseName,
          'date': _selectedWorkout!.workoutDate.toIso8601String(),
          'duration': _selectedWorkout!.durationMinutes,
          'exercises': [
            {
              'name': _selectedWorkout!.exerciseName,
              'sets': _selectedWorkout!.setIds.length,
            }
          ],
        };
      }

      await SocialService.createPost(
        content: _captionController.text,
        imagePath: _selectedImage!.path,
        workoutSnapshot: workoutSnapshot,
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to refresh feed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Yeni Paylaşım'),
        backgroundColor: AppColors.darkSurface,
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _sharePost,
            child: _isUploading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Paylaş', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  image: _selectedImage != null 
                    ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                    : null
                ),
                child: _selectedImage == null 
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Fotoğraf Seç', style: TextStyle(color: Colors.grey))
                      ],
                    )
                  : null,
              ),
            ),
            
            const SizedBox(height: 16),

            // Workout Selector
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.fitness_center, color: AppColors.primaryColor),
              ),
              title: Text(_selectedWorkout?.exerciseName ?? 'Antrenman Ekle (İsteğe Bağlı)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: _selectedWorkout != null 
                ? Text('${_selectedWorkout!.durationMinutes} dakika • ${_selectedWorkout!.setIds.length} set', style: const TextStyle(color: Colors.grey))
                : const Text('Antrenman geçmişinden seçin', style: TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _selectWorkout,
            ),

            const Divider(color: Colors.grey),

            // Caption
            TextField(
              controller: _captionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Bir açıklama yaz...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
