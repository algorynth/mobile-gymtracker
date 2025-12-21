import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../models/workout_template.dart';
import '../models/exercise.dart';
import '../data/exercise_library.dart';
import '../providers/custom_templates_provider.dart';

class CreateTemplateScreen extends ConsumerStatefulWidget {
  final WorkoutTemplate? existingTemplate; // Düzenleme için

  const CreateTemplateScreen({Key? key, this.existingTemplate}) : super(key: key);

  @override
  ConsumerState<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends ConsumerState<CreateTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'custom';
  List<TemplateExercise> _exercises = [];

  final List<Map<String, String>> _categories = [
    {'value': 'push', 'label': 'Push (İtme)', 'icon': '💪'},
    {'value': 'pull', 'label': 'Pull (Çekme)', 'icon': '🏋️'},
    {'value': 'legs', 'label': 'Bacak', 'icon': '🦵'},
    {'value': 'upper', 'label': 'Üst Vücut', 'icon': '👆'},
    {'value': 'lower', 'label': 'Alt Vücut', 'icon': '👇'},
    {'value': 'full_body', 'label': 'Full Body', 'icon': '🔥'},
    {'value': 'custom', 'label': 'Özel', 'icon': '⚡'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingTemplate != null) {
      _nameController.text = widget.existingTemplate!.name;
      _descriptionController.text = widget.existingTemplate!.description ?? '';
      _selectedCategory = widget.existingTemplate!.category;
      _exercises = List.from(widget.existingTemplate!.exercises);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTemplate != null;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Şablonu Düzenle' : 'Yeni Şablon'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _deleteTemplate,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Şablon Adı
              Text('Şablon Adı', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Çekiş Günü',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şablon adı gerekli';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Açıklama
              Text('Açıklama (Opsiyonel)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Şablon hakkında kısa açıklama...',
                ),
              ),

              const SizedBox(height: 20),

              // Kategori Seçimi
              Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat['value'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat['value']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.darkCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : AppColors.darkBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat['icon']!, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            cat['label']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Egzersizler
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Egzersizler', style: Theme.of(context).textTheme.titleMedium),
                  TextButton.icon(
                    onPressed: _showExercisePicker,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Ekle'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_exercises.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder, style: BorderStyle.solid),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.fitness_center, size: 48, color: AppColors.textSecondary),
                        const SizedBox(height: 12),
                        Text(
                          'Henüz egzersiz eklenmedi',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"Ekle" butonuna tıklayarak egzersiz ekleyin',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _exercises.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = _exercises.removeAt(oldIndex);
                      _exercises.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];
                    return _buildExerciseCard(exercise, index);
                  },
                ),

              const SizedBox(height: 32),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _exercises.isEmpty ? null : _saveTemplate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.darkCard,
                  ),
                  child: Text(
                    isEditing ? 'Değişiklikleri Kaydet' : 'Şablonu Kaydet',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(TemplateExercise exercise, int index) {
    return Container(
      key: ValueKey(exercise.exerciseId + index.toString()),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          exercise.exerciseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${exercise.targetSets}×${exercise.targetReps} • ${exercise.restSeconds}s dinlenme',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _editExercise(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
              onPressed: () => _removeExercise(index),
            ),
            const Icon(Icons.drag_handle, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showExercisePicker() {
    final exercises = ExerciseLibrary.predefinedExercises;
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final filtered = searchQuery.isEmpty
              ? exercises
              : exercises.where((e) => 
                  e.name.toLowerCase().contains(searchQuery.toLowerCase())
                ).toList();

          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) => Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Egzersiz ara...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setModalState(() => searchQuery = value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final exercise = filtered[index];
                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(_getMuscleGroupName(exercise.muscleGroup)),
                        trailing: const Icon(Icons.add_circle_outline, color: AppColors.accentGreen),
                        onTap: () {
                          Navigator.pop(context);
                          _showExerciseConfig(exercise);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExerciseConfig(Exercise exercise) {
    int sets = 3;
    int reps = 10;
    int rest = 90;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.darkSurface,
          title: Text(exercise.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNumberPicker('Set Sayısı', sets, 1, 10, (v) {
                setDialogState(() => sets = v);
              }),
              const SizedBox(height: 16),
              _buildNumberPicker('Tekrar Sayısı', reps, 1, 30, (v) {
                setDialogState(() => reps = v);
              }),
              const SizedBox(height: 16),
              _buildNumberPicker('Dinlenme (sn)', rest, 30, 300, (v) {
                setDialogState(() => rest = v);
              }, step: 15),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _exercises.add(TemplateExercise(
                    exerciseId: exercise.id,
                    exerciseName: exercise.name,
                    targetSets: sets,
                    targetReps: reps,
                    restSeconds: rest,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPicker(String label, int value, int min, int max, Function(int) onChanged, {int step = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: value > min ? () => onChanged(value - step) : null,
            ),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: value < max ? () => onChanged(value + step) : null,
            ),
          ],
        ),
      ],
    );
  }

  void _editExercise(int index) {
    final exercise = _exercises[index];
    int sets = exercise.targetSets;
    int reps = exercise.targetReps;
    int rest = exercise.restSeconds;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.darkSurface,
          title: Text(exercise.exerciseName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNumberPicker('Set Sayısı', sets, 1, 10, (v) {
                setDialogState(() => sets = v);
              }),
              const SizedBox(height: 16),
              _buildNumberPicker('Tekrar Sayısı', reps, 1, 30, (v) {
                setDialogState(() => reps = v);
              }),
              const SizedBox(height: 16),
              _buildNumberPicker('Dinlenme (sn)', rest, 30, 300, (v) {
                setDialogState(() => rest = v);
              }, step: 15),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _exercises[index] = TemplateExercise(
                    exerciseId: exercise.exerciseId,
                    exerciseName: exercise.exerciseName,
                    targetSets: sets,
                    targetReps: reps,
                    restSeconds: rest,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  String _getMuscleGroupName(String muscleGroup) {
    const map = {
      'chest': 'Göğüs',
      'back': 'Sırt',
      'shoulders': 'Omuz',
      'arms': 'Kol',
      'legs': 'Bacak',
      'core': 'Karın',
      'full_body': 'Tüm Vücut',
    };
    return map[muscleGroup] ?? muscleGroup;
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_exercises.isEmpty) return;

    final estimatedDuration = _exercises.length * 8; // Her egzersiz ~8 dk

    if (widget.existingTemplate != null) {
      // Düzenleme
      final updated = widget.existingTemplate!.copyWith(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        exercises: _exercises,
        category: _selectedCategory,
        estimatedDuration: estimatedDuration,
      );
      await ref.read(customTemplatesProvider.notifier).updateTemplate(updated);
    } else {
      // Yeni oluştur
      await ref.read(customTemplatesProvider.notifier).createTemplate(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        exercises: _exercises,
        category: _selectedCategory,
        estimatedDuration: estimatedDuration,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingTemplate != null 
              ? 'Şablon güncellendi!' 
              : 'Şablon kaydedildi!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _deleteTemplate() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text('Şablonu Sil'),
        content: const Text('Bu şablonu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true && widget.existingTemplate != null) {
      await ref.read(customTemplatesProvider.notifier).deleteTemplate(widget.existingTemplate!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
