import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/body_measurements_provider.dart';
import '../utils/validators.dart';
import '../utils/date_formatter.dart';

class BodyTrackingScreen extends ConsumerStatefulWidget {
  const BodyTrackingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BodyTrackingScreen> createState() => _BodyTrackingScreenState();
}

class _BodyTrackingScreenState extends ConsumerState<BodyTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _muscleMassController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveMeasurement() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(bodyMeasurementsProvider.notifier).addMeasurement(
            weightKg: double.parse(_weightController.text),
            bodyFatPercentage: _bodyFatController.text.isNotEmpty
                ? double.parse(_bodyFatController.text)
                : null,
            muscleMassPercentage: _muscleMassController.text.isNotEmpty
                ? double.parse(_muscleMassController.text)
                : null,
            measurementDate: _selectedDate,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ölçüm kaydedildi!'),
            backgroundColor: AppColors.success,
          ),
        );
        _weightController.clear();
        _bodyFatController.clear();
        _muscleMassController.clear();
        setState(() {
          _selectedDate = DateTime.now();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final measurements = ref.watch(bodyMeasurementsProvider);
    final stats = ref.watch(bodyStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Vücut Takibi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Summary
            if (stats.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          'Mevcut',
                          '${stats['currentWeight']?.toStringAsFixed(1) ?? '--'} kg',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.textPrimary.withOpacity(0.3),
                        ),
                        _buildStatColumn(
                          'Başlangıç',
                          '${stats['startWeight']?.toStringAsFixed(1) ?? '--'} kg',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.textPrimary.withOpacity(0.3),
                        ),
                        _buildStatColumn(
                          'Değişim',
                          '${(stats['weightChange'] ?? 0) >= 0 ? '+' : ''}${stats['weightChange']?.toStringAsFixed(1) ?? '--'} kg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Add Measurement Form
            Text(
              'Yeni Ölçüm Ekle',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Date Selector
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                color: AppColors.primaryColor),
                            const SizedBox(width: 12),
                            Text(
                              DateFormatter.formatDate(_selectedDate),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_drop_down,
                                color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weight Input
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      validator: Validators.isValidWeight,
                      decoration: const InputDecoration(
                        labelText: 'Kilo (kg)',
                        hintText: 'Örn: 75.5',
                        prefixIcon: Icon(Icons.monitor_weight_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Body Fat Input
                    TextFormField(
                      controller: _bodyFatController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return Validators.isValidPercentage(value,
                              fieldName: 'Yağ oranı');
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Yağ Oranı (%) - Opsiyonel',
                        hintText: 'Örn: 18',
                        prefixIcon: Icon(Icons.pie_chart_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Muscle Mass Input
                    TextFormField(
                      controller: _muscleMassController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return Validators.isValidPercentage(value,
                              fieldName: 'Kas oranı');
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Kas Oranı (%) - Opsiyonel',
                        hintText: 'Örn: 42',
                        prefixIcon: Icon(Icons.fitness_center_rounded),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveMeasurement,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('Ölçümü Kaydet'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Measurement History
            Text(
              'Geçmiş Ölçümler',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            if (measurements.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.insert_chart_outlined_rounded,
                        size: 80,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz ölçüm yok',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: measurements.length,
                itemBuilder: (context, index) {
                  final measurement = measurements[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormatter.formatSmartDate(
                                  measurement.measurementDate),
                              style:
                                  Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.error),
                              onPressed: () async {
                                await ref
                                    .read(bodyMeasurementsProvider.notifier)
                                    .deleteMeasurement(measurement);
                              },
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.darkBorder),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMeasurementDetail(
                              'Kilo',
                              '${measurement.weightKg.toStringAsFixed(1)} kg',
                              Icons.monitor_weight_rounded,
                            ),
                            if (measurement.bodyFatPercentage != null)
                              _buildMeasurementDetail(
                                'Yağ',
                                '${measurement.bodyFatPercentage!.toStringAsFixed(1)}%',
                                Icons.pie_chart_rounded,
                              ),
                            if (measurement.muscleMassPercentage != null)
                              _buildMeasurementDetail(
                                'Kas',
                                '${measurement.muscleMassPercentage!.toStringAsFixed(1)}%',
                                Icons.fitness_center_rounded,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary.withOpacity(0.8),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildMeasurementDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
