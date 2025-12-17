import 'package:uuid/uuid.dart';
import '../models/body_measurement.dart';
import 'database_service.dart';

class BodyMeasurementService {
  static const _uuid = Uuid();

  // Yeni ölçüm ekle
  static Future<void> addMeasurement({
    required double weightKg,
    double? bodyFatPercentage,
    double? muscleMassPercentage,
    DateTime? measurementDate,
    String? notes,
  }) async {
    final measurement = BodyMeasurement(
      id: _uuid.v4(),
      weightKg: weightKg,
      bodyFatPercentage: bodyFatPercentage,
      muscleMassPercentage: muscleMassPercentage,
      measurementDate: measurementDate ?? DateTime.now(),
      notes: notes,
    );

    await DatabaseService.bodyMeasurementsBox.add(measurement);
  }

  // Tüm ölçümleri al (tarihe göre sıralı)
  static List<BodyMeasurement> getAllMeasurements() {
    final measurements = DatabaseService.bodyMeasurementsBox.values.toList();
    measurements.sort((a, b) => b.measurementDate.compareTo(a.measurementDate));
    return measurements;
  }

  // En son ölçümü al
  static BodyMeasurement? getLatestMeasurement() {
    final measurements = getAllMeasurements();
    return measurements.isEmpty ? null : measurements.first;
  }

  // Tarih aralığındaki ölçümleri al
  static List<BodyMeasurement> getMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return getAllMeasurements()
        .where((m) =>
            m.measurementDate.isAfter(startDate) &&
            m.measurementDate.isBefore(endDate))
        .toList();
  }

  // Son N günlük ölçümleri al
  static List<BodyMeasurement> getRecentMeasurements(int days) {
    final startDate = DateTime.now().subtract(Duration(days: days));
    return getAllMeasurements()
        .where((m) => m.measurementDate.isAfter(startDate))
        .toList();
  }

  // Ölçüm sil
  static Future<void> deleteMeasurement(BodyMeasurement measurement) async {
    await measurement.delete();
  }

  // Ölçüm güncelle
  static Future<void> updateMeasurement(
    BodyMeasurement measurement, {
    double? weightKg,
    double? bodyFatPercentage,
    double? muscleMassPercentage,
    String? notes,
  }) async {
    final updatedMeasurement = BodyMeasurement(
      id: measurement.id,
      weightKg: weightKg ?? measurement.weightKg,
      bodyFatPercentage: bodyFatPercentage ?? measurement.bodyFatPercentage,
      muscleMassPercentage: muscleMassPercentage ?? measurement.muscleMassPercentage,
      measurementDate: measurement.measurementDate,
      notes: notes ?? measurement.notes,
    );

    await measurement.delete();
    await DatabaseService.bodyMeasurementsBox.add(updatedMeasurement);
  }

  // İstatistikler
  static Map<String, double?> getStatistics() {
    final measurements = getAllMeasurements();
    if (measurements.isEmpty) return {};

    final latest = measurements.first;
    final oldest = measurements.last;

    return {
      'currentWeight': latest.weightKg,
      'startWeight': oldest.weightKg,
      'weightChange': latest.weightKg - oldest.weightKg,
      'currentBodyFat': latest.bodyFatPercentage,
      'currentMuscleMass': latest.muscleMassPercentage,
    };
  }
}
