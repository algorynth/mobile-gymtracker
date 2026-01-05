import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/body_measurement.dart';
import '../services/body_measurement_service.dart';

// Body Measurements List Provider
final bodyMeasurementsProvider = StateNotifierProvider<BodyMeasurementsNotifier, List<BodyMeasurement>>((ref) {
  return BodyMeasurementsNotifier();
});

class BodyMeasurementsNotifier extends StateNotifier<List<BodyMeasurement>> {
  BodyMeasurementsNotifier() : super([]) {
    _loadMeasurements();
  }

  void _loadMeasurements() {
    state = BodyMeasurementService.getAllMeasurements();
  }

  Future<void> addMeasurement({
    required double weightKg,
    double? bodyFatPercentage,
    double? bodyFatKg,
    double? muscleMassPercentage,
    double? muscleMassKg,
    DateTime? measurementDate,
    String? notes,
  }) async {
    await BodyMeasurementService.addMeasurement(
      weightKg: weightKg,
      bodyFatPercentage: bodyFatPercentage,
      bodyFatKg: bodyFatKg,
      muscleMassPercentage: muscleMassPercentage,
      muscleMassKg: muscleMassKg,
      measurementDate: measurementDate,
      notes: notes,
    );
    _loadMeasurements();
  }

  Future<void> deleteMeasurement(BodyMeasurement measurement) async {
    await BodyMeasurementService.deleteMeasurement(measurement);
    _loadMeasurements();
  }

  void refresh() {
    _loadMeasurements();
  }

  BodyMeasurement? getLatest() {
    return state.isEmpty ? null : state.first;
  }

  List<BodyMeasurement> getRecent(int days) {
    return BodyMeasurementService.getRecentMeasurements(days);
  }
}

// Latest Measurement Provider
final latestMeasurementProvider = Provider<BodyMeasurement?>((ref) {
  final measurements = ref.watch(bodyMeasurementsProvider);
  return measurements.isEmpty ? null : measurements.first;
});

// Statistics Provider
final bodyStatsProvider = Provider<Map<String, double?>>((ref) {
  ref.watch(bodyMeasurementsProvider); // Watch to trigger rebuild
  return BodyMeasurementService.getStatistics();
});
