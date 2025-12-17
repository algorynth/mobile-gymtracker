import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import '../models/body_measurement.dart';
import '../utils/date_formatter.dart';

class WeightChartWidget extends StatelessWidget {
  final List<BodyMeasurement> measurements;
  final double height;

  const WeightChartWidget({
    Key? key,
    required this.measurements,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty || measurements.length < 2) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart_rounded,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'En az 2 ölçüm gerekli',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Son 30 günü al ve tarihe göre sırala
    final sortedMeasurements = measurements
        .where((m) => m.measurementDate.isAfter(
            DateTime.now().subtract(const Duration(days: 30))))
        .toList()
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    if (sortedMeasurements.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('Son 30 günde ölçüm yok'),
        ),
      );
    }

    // Grafik noktalarını oluştur
    final spots = <FlSpot>[];
    for (var i = 0; i < sortedMeasurements.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedMeasurements[i].weightKg));
    }

    // Min ve max değerleri bul
    final minWeight = sortedMeasurements
        .map((m) => m.weightKg)
        .reduce((a, b) => a < b ? a : b);
    final maxWeight = sortedMeasurements
        .map((m) => m.weightKg)
        .reduce((a, b) => a > b ? a : b);
    
    final padding = (maxWeight - minWeight) * 0.2;

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kilo Trendi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Son 30 gün',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxWeight - minWeight) / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.darkBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (sortedMeasurements.length / 4).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= sortedMeasurements.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormatter.formatDayMonth(
                                sortedMeasurements[index].measurementDate),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: (maxWeight - minWeight) / 4,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (sortedMeasurements.length - 1).toDouble(),
                minY: minWeight - padding,
                maxY: maxWeight + padding,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentGreen,
                        AppColors.primaryColor,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primaryColor,
                          strokeWidth: 2,
                          strokeColor: AppColors.textPrimary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentGreen.withValues(alpha: 0.3),
                          AppColors.primaryColor.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        final measurement = sortedMeasurements[index];
                        return LineTooltipItem(
                          '${measurement.weightKg.toStringAsFixed(1)} kg\n${DateFormatter.formatDate(measurement.measurementDate)}',
                          const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyCompositionChartWidget extends StatelessWidget {
  final List<BodyMeasurement> measurements;
  final double height;

  const BodyCompositionChartWidget({
    Key? key,
    required this.measurements,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Yağ ve kas oranı olan ölçümleri filtrele
    final filteredMeasurements = measurements
        .where((m) => m.bodyFatPercentage != null || m.muscleMassPercentage != null)
        .toList()
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    if (filteredMeasurements.length < 2) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_rounded,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Yağ/kas oranı verisi yetersiz',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Grafik noktalarını oluştur
    final fatSpots = <FlSpot>[];
    final muscleSpots = <FlSpot>[];
    
    for (var i = 0; i < filteredMeasurements.length; i++) {
      final m = filteredMeasurements[i];
      if (m.bodyFatPercentage != null) {
        fatSpots.add(FlSpot(i.toDouble(), m.bodyFatPercentage!));
      }
      if (m.muscleMassPercentage != null) {
        muscleSpots.add(FlSpot(i.toDouble(), m.muscleMassPercentage!));
      }
    }

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vücut Kompozisyonu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  _buildLegend(context, 'Yağ', AppColors.accentOrange),
                  const SizedBox(width: 12),
                  _buildLegend(context, 'Kas', AppColors.accentPurple),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.darkBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 60,
                lineBarsData: [
                  if (fatSpots.isNotEmpty)
                    LineChartBarData(
                      spots: fatSpots,
                      isCurved: true,
                      color: AppColors.accentOrange,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                    ),
                  if (muscleSpots.isNotEmpty)
                    LineChartBarData(
                      spots: muscleSpots,
                      isCurved: true,
                      color: AppColors.accentPurple,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
