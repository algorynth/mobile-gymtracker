import 'package:hive/hive.dart';

part 'progress_photo.g.dart';

@HiveType(typeId: 7)
class ProgressPhoto {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final DateTime photoDate;

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final String category; // 'front', 'side', 'back'

  @HiveField(5)
  final double? weight; // Fotoğraf çekildiği andaki kilo

  ProgressPhoto({
    required this.id,
    required this.imagePath,
    required this.photoDate,
    this.note,
    this.category = 'front',
    this.weight,
  });

  ProgressPhoto copyWith({
    String? id,
    String? imagePath,
    DateTime? photoDate,
    String? note,
    String? category,
    double? weight,
  }) {
    return ProgressPhoto(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      photoDate: photoDate ?? this.photoDate,
      note: note ?? this.note,
      category: category ?? this.category,
      weight: weight ?? this.weight,
    );
  }
}
