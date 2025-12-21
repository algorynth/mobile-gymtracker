import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_template.dart';

/// Custom Templates Provider
/// Kullanıcının oluşturduğu özel antrenman şablonlarını yönetir

final customTemplatesProvider = StateNotifierProvider<CustomTemplatesNotifier, List<WorkoutTemplate>>((ref) {
  return CustomTemplatesNotifier();
});

class CustomTemplatesNotifier extends StateNotifier<List<WorkoutTemplate>> {
  static const String _boxName = 'custom_templates';
  late Box<WorkoutTemplate> _box;

  CustomTemplatesNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<WorkoutTemplate>(_boxName);
    state = _box.values.toList();
  }

  /// Yeni şablon oluştur
  Future<WorkoutTemplate> createTemplate({
    required String name,
    String? description,
    required List<TemplateExercise> exercises,
    String category = 'custom',
    int estimatedDuration = 60,
  }) async {
    final template = WorkoutTemplate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      exercises: exercises,
      category: category,
      estimatedDuration: estimatedDuration,
      createdAt: DateTime.now(),
    );

    await _box.put(template.id, template);
    state = [...state, template];
    return template;
  }

  /// Şablonu güncelle
  Future<void> updateTemplate(WorkoutTemplate template) async {
    await _box.put(template.id, template);
    state = state.map((t) => t.id == template.id ? template : t).toList();
  }

  /// Şablonu sil
  Future<void> deleteTemplate(String id) async {
    await _box.delete(id);
    state = state.where((t) => t.id != id).toList();
  }

  /// Şablona egzersiz ekle
  Future<void> addExerciseToTemplate(String templateId, TemplateExercise exercise) async {
    final templateIndex = state.indexWhere((t) => t.id == templateId);
    if (templateIndex == -1) return;

    final template = state[templateIndex];
    final updatedExercises = [...template.exercises, exercise];
    final updatedTemplate = template.copyWith(exercises: updatedExercises);
    
    await updateTemplate(updatedTemplate);
  }

  /// Şablondan egzersiz çıkar
  Future<void> removeExerciseFromTemplate(String templateId, int exerciseIndex) async {
    final templateIndex = state.indexWhere((t) => t.id == templateId);
    if (templateIndex == -1) return;

    final template = state[templateIndex];
    final updatedExercises = List<TemplateExercise>.from(template.exercises);
    updatedExercises.removeAt(exerciseIndex);
    final updatedTemplate = template.copyWith(exercises: updatedExercises);
    
    await updateTemplate(updatedTemplate);
  }

  /// ID'ye göre şablon getir
  WorkoutTemplate? getTemplateById(String id) {
    try {
      return state.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
