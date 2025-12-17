import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/user_profile_provider.dart';
import '../utils/validators.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  
  String _selectedGender = 'male';
  String _selectedActivityLevel = 'moderate';
  String _selectedGoal = 'maintain';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final profile = ref.read(userProfileProvider);
    if (profile != null) {
      _nameController.text = profile.name;
      _ageController.text = profile.age.toString();
      _heightController.text = profile.heightCm.toString();
      _selectedGender = profile.gender;
      _selectedActivityLevel = profile.activityLevel;
      _selectedGoal = profile.goal;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profile = ref.read(userProfileProvider);
      
      if (profile == null) {
        // Create new profile
        await ref.read(userProfileProvider.notifier).createProfile(
              name: _nameController.text,
              age: int.parse(_ageController.text),
              gender: _selectedGender,
              heightCm: double.parse(_heightController.text),
              activityLevel: _selectedActivityLevel,
              goal: _selectedGoal,
            );
      } else {
        // Update existing profile
        await ref.read(userProfileProvider.notifier).updateProfile(
              name: _nameController.text,
              age: int.parse(_ageController.text),
              gender: _selectedGender,
              heightCm: double.parse(_heightController.text),
              activityLevel: _selectedActivityLevel,
              goal: _selectedGoal,
            );
      }

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil kaydedildi!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          if (profile != null && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _selectedGender == 'male' ? Icons.face_rounded : Icons.face_3_rounded,
                size: 80,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            if (profile == null || _isEditing) ...[
              // Profile Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile == null ? 'Profil Oluştur' : 'Profili Düzenle',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),

                      // Name
                      TextFormField(
                        controller: _nameController,
                        validator: (v) =>
                            Validators.required(v, fieldName: 'İsim'),
                        decoration: const InputDecoration(
                          labelText: 'İsim',
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Age and Height
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              validator: Validators.isValidAge,
                              decoration: const InputDecoration(
                                labelText: 'Yaş',
                                prefixIcon: Icon(Icons.cake_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              validator: Validators.isValidHeight,
                              decoration: const InputDecoration(
                                labelText: 'Boy (cm)',
                                prefixIcon: Icon(Icons.height_rounded),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Gender
                      Text(
                        'Cinsiyet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildChoiceChip(
                              'Erkek',
                              _selectedGender == 'male',
                              () => setState(() => _selectedGender = 'male'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildChoiceChip(
                              'Kadın',
                              _selectedGender == 'female',
                              () => setState(() => _selectedGender = 'female'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Activity Level
                      Text(
                        'Aktivite Seviyesi',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _buildActivityLevelSelector(),
                      const SizedBox(height: 24),

                      // Goal
                      Text(
                        'Hedef',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _buildGoalSelector(),
                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text('Kaydet'),
                          ),
                        ),
                      ),
                      if (_isEditing) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              _loadProfile();
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            child: const Text('İptal'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Profile View
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 24),
                    _buildProfileInfo(
                      'Yaş',
                      '${profile.age} yaşında',
                      Icons.cake_rounded,
                    ),
                    const Divider(color: AppColors.darkBorder, height: 32),
                    _buildProfileInfo(
                      'Boy',
                      '${profile.heightCm.toStringAsFixed(0)} cm',
                      Icons.height_rounded,
                    ),
                    const Divider(color: AppColors.darkBorder, height: 32),
                    _buildProfileInfo(
                      'Cinsiyet',
                      profile.gender == 'male' ? 'Erkek' : 'Kadın',
                      Icons.person_rounded,
                    ),
                    const Divider(color: AppColors.darkBorder, height: 32),
                    _buildProfileInfo(
                      'Aktivite',
                      _getActivityLevelName(profile.activityLevel),
                      Icons.fitness_center_rounded,
                    ),
                    const Divider(color: AppColors.darkBorder, height: 32),
                    _buildProfileInfo(
                      'Hedef',
                      _getGoalName(profile.goal),
                      Icons.flag_rounded,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // App Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Gym Tracker',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Versiyon 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '💪 Fit kal, güçlü ol!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primaryColor
                : AppColors.darkBorder,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLevelSelector() {
    const levels = {
      'sedentary': 'Az Hareketli',
      'light': 'Hafif Aktif',
      'moderate': 'Orta Aktif',
      'active': 'Çok Aktif',
      'very_active': 'Ekstra Aktif',
    };

    return Column(
      children: levels.entries.map((entry) {
        final isSelected = _selectedActivityLevel == entry.key;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedActivityLevel = entry.key),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppColors.primaryColor.withOpacity(0.2) : AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : AppColors.darkBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color:
                        isSelected ? AppColors.primaryColor : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    entry.value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoalSelector() {
    const goals = {
      'lose_weight': 'Kilo Ver',
      'maintain': 'Kilonu Koru',
      'gain_muscle': 'Kas Kazan',
    };

    return Row(
      children: goals.entries.map((entry) {
        final isSelected = _selectedGoal == entry.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildChoiceChip(
              entry.value,
              isSelected,
              () => setState(() => _selectedGoal = entry.key),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  String _getActivityLevelName(String level) {
    const map = {
      'sedentary': 'Az Hareketli',
      'light': 'Hafif Aktif',
      'moderate': 'Orta Aktif',
      'active': 'Çok Aktif',
      'very_active': 'Ekstra Aktif',
    };
    return map[level] ?? level;
  }

  String _getGoalName(String goal) {
    const map = {
      'lose_weight': 'Kilo Ver',
      'maintain': 'Kilonu Koru',
      'gain_muscle': 'Kas Kazan',
    };
    return map[goal] ?? goal;
  }
}
