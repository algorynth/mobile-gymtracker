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
  
  @HiveField(6)
  final double? bodyFatKg;
  
  @HiveField(7)
  final double? muscleMassKg;

  BodyMeasurement({
    required this.id,
    required this.weightKg,
    this.bodyFatPercentage,
    this.muscleMassPercentage,
    required this.measurementDate,
    this.notes,
    this.bodyFatKg,
    this.muscleMassKg,
  });

  // Kas kütlesi (kg olarak) - direkt girilmişse onu kullan, yoksa hesapla
  double? get muscleMassKgValue {
    if (muscleMassKg != null) return muscleMassKg;
    if (muscleMassPercentage != null) {
      return weightKg * (muscleMassPercentage! / 100);
    }
    return null;
  }

  // Yağ kütlesi (kg olarak) - direkt girilmişse onu kullan, yoksa hesapla
  double? get fatMassKgValue {
    if (bodyFatKg != null) return bodyFatKg;
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
