import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../providers/progress_photos_provider.dart';
import '../providers/body_measurements_provider.dart';
import '../models/progress_photo.dart';
import '../utils/date_formatter.dart';

class ProgressPhotosScreen extends ConsumerStatefulWidget {
  const ProgressPhotosScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProgressPhotosScreen> createState() => _ProgressPhotosScreenState();
}

class _ProgressPhotosScreenState extends ConsumerState<ProgressPhotosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String category) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        final latestMeasurement = ref.read(latestMeasurementProvider);
        
        await ref.read(progressPhotosProvider.notifier).addPhoto(
          imagePath: image.path,
          photoDate: DateTime.now(),
          category: category,
          weight: latestMeasurement?.weightKg,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fotoğraf eklendi! 📸'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf seçilemedi: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto(String category) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        final latestMeasurement = ref.read(latestMeasurementProvider);
        
        await ref.read(progressPhotosProvider.notifier).addPhoto(
          imagePath: image.path,
          photoDate: DateTime.now(),
          category: category,
          weight: latestMeasurement?.weightKg,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fotoğraf eklendi! 📸'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kamera açılamadı: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showAddPhotoOptions(String category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Fotoğraf Ekle',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Kamera',
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto(category);
                  },
                ),
                _buildPhotoOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Galeri',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(category);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppColors.primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(progressPhotosProvider);
    final photoCounts = ref.watch(photoCountsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('İlerleme Fotoğrafları'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Tümü (${photoCounts['total']})'),
            Tab(text: 'Ön (${photoCounts['front']})'),
            Tab(text: 'Yan (${photoCounts['side']})'),
            Tab(text: 'Arka (${photoCounts['back']})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPhotoGrid(photos, 'all'),
          _buildPhotoGrid(photos.where((p) => p.category == 'front').toList(), 'front'),
          _buildPhotoGrid(photos.where((p) => p.category == 'side').toList(), 'side'),
          _buildPhotoGrid(photos.where((p) => p.category == 'back').toList(), 'back'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategorySelector(),
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Fotoğraf Ekle'),
      ),
    );
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Kategori Seç',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryOption('Ön', 'front', Icons.person_rounded),
                _buildCategoryOption('Yan', 'side', Icons.person_outline_rounded),
                _buildCategoryOption('Arka', 'back', Icons.accessibility_new_rounded),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryOption(String label, String category, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showAddPhotoOptions(category);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.primaryColor),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<ProgressPhoto> photos, String category) {
    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_camera_rounded,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz fotoğraf yok',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'İlk ilerleme fotoğrafını ekle!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDisabled,
                  ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return _buildPhotoCard(photo);
      },
    );
  }

  Widget _buildPhotoCard(ProgressPhoto photo) {
    return GestureDetector(
      onTap: () => _showPhotoDetail(photo),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildPhotoImage(photo),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.formatDate(photo.photoDate),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (photo.weight != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${photo.weight!.toStringAsFixed(1)} kg',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoImage(ProgressPhoto photo) {
    final file = File(photo.imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.darkSurface,
      child: const Center(
        child: Icon(
          Icons.broken_image_rounded,
          size: 48,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  void _showPhotoDetail(ProgressPhoto photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.darkSurface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.75,
                  child: _buildPhotoImage(photo),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.darkBackground.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormatter.formatDate(photo.photoDate),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (photo.weight != null)
                        Text(
                          '${photo.weight!.toStringAsFixed(1)} kg',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref.read(progressPhotosProvider.notifier).deletePhoto(photo);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fotoğraf silindi'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
