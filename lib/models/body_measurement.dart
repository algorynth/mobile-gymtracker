import 'package:hive/hive.dart';

part 'body_measurement.g.dart';

@HiveType(typeId: 1)
class BodyMeasurement extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double weightKg;

  @HiveField(2)
  final double? bodyFatPercentage;

  @HiveField(3)
  final double? muscleMassPercentage;

  @HiveField(4)
  final DateTime measurementDate;

  @HiveField(5)
  final String? notes;

  BodyMeasurement({
    required this.id,
    required this.weightKg,
    this.bodyFatPercentage,
    this.muscleMassPercentage,
    required this.measurementDate,
    this.notes,
  });

  // Kas kütlesi hesaplama (kg olarak)
  double? get muscleMassKg {
    if (muscleMassPercentage != null) {
      return weightKg * (muscleMassPercentage! / 100);
    }
    return null;
  }

  // Yağ kütlesi hesaplama (kg olarak)
  double? get fatMassKg {
    if (bodyFatPercentage != null) {
      return weightKg * (bodyFatPercentage! / 100);
    }
    return null;
  }

  // Yağsız vücut kütlesi (Lean Body Mass)
  double? get leanBodyMass {
    if (bodyFatPercentage != null) {
      return weightKg * (1 - bodyFatPercentage! / 100);
    }
    return null;
  }
}
