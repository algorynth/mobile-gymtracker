import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/progress_photo.dart';
import '../services/database_service.dart';

class ProgressPhotosNotifier extends StateNotifier<List<ProgressPhoto>> {
  ProgressPhotosNotifier() : super([]) {
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final box = DatabaseService.progressPhotosBox;
    final photos = box.values.toList();
    photos.sort((a, b) => b.photoDate.compareTo(a.photoDate));
    state = photos;
  }

  Future<void> addPhoto({
    required String imagePath,
    required DateTime photoDate,
    String? note,
    String category = 'front',
    double? weight,
  }) async {
    final photo = ProgressPhoto(
      id: const Uuid().v4(),
      imagePath: imagePath,
      photoDate: photoDate,
      note: note,
      category: category,
      weight: weight,
    );

    await DatabaseService.progressPhotosBox.add(photo);
    state = [photo, ...state];
  }

  Future<void> deletePhoto(ProgressPhoto photo) async {
    final box = DatabaseService.progressPhotosBox;
    final index = box.values.toList().indexWhere((p) => p.id == photo.id);
    if (index != -1) {
      await box.deleteAt(index);
      state = state.where((p) => p.id != photo.id).toList();
    }
  }

  List<ProgressPhoto> getPhotosByCategory(String category) {
    return state.where((p) => p.category == category).toList();
  }
}

final progressPhotosProvider =
    StateNotifierProvider<ProgressPhotosNotifier, List<ProgressPhoto>>((ref) {
  return ProgressPhotosNotifier();
});

// Kategori bazlı fotoğraf sayıları
final photoCountsProvider = Provider<Map<String, int>>((ref) {
  final photos = ref.watch(progressPhotosProvider);
  return {
    'front': photos.where((p) => p.category == 'front').length,
    'side': photos.where((p) => p.category == 'side').length,
    'back': photos.where((p) => p.category == 'back').length,
    'total': photos.length,
  };
});
