import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/body_measurements_provider.dart';
import '../widgets/charts_widget.dart';

class ProgressChartsScreen extends ConsumerWidget {
  const ProgressChartsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurements = ref.watch(bodyMeasurementsProvider);
    final stats = ref.watch(bodyStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('İlerleme Grafikleri'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Özet İstatistikler
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Toplam Ölçüm',
                    '${measurements.length}',
                    Icons.straighten_rounded,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: AppColors.textPrimary.withValues(alpha: 0.3),
                  ),
                  _buildStatItem(
                    context,
                    'Değişim',
                    '${(stats['weightChange'] as double? ?? 0).toStringAsFixed(1)} kg',
                    stats['weightChange'] != null && (stats['weightChange'] as double) < 0
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: AppColors.textPrimary.withValues(alpha: 0.3),
                  ),
                  _buildStatItem(
                    context,
                    'Mevcut',
                    '${(stats['currentWeight'] as double? ?? 0).toStringAsFixed(1)} kg',
                    Icons.monitor_weight_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Kilo Trendi Grafiği
            Text(
              '📈 Kilo Trendi',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            WeightChartWidget(
              measurements: measurements,
              height: 250,
            ),

            const SizedBox(height: 24),

            // Vücut Kompozisyonu Grafiği
            Text(
              '📊 Vücut Kompozisyonu',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            BodyCompositionChartWidget(
              measurements: measurements,
              height: 250,
            ),

            const SizedBox(height: 24),

            // Özet Bilgiler
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 İpuçları',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildTip(context, '• Haftada 0.5-1 kg kilo kaybı sağlıklıdır'),
                  _buildTip(context, '• Kas kazanmak kilo artışı olarak görünebilir'),
                  _buildTip(context, '• Düzenli ölçüm yapmak ilerlemeyi takip etmenizi kolaylaştırır'),
                  _buildTip(context, '• Sabah aç karnına ölçüm yapmak daha tutarlı sonuç verir'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildTip(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}
