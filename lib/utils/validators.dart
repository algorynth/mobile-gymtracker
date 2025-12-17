class Validators {
  // Boş değer kontrolü
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "Bu alan"} zorunludur';
    }
    return null;
  }

  // Sayı kontrolü
  static String? isNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "Bu alan"} zorunludur';
    }
    if (double.tryParse(value) == null) {
      return 'Geçerli bir sayı giriniz';
    }
    return null;
  }

  // Pozitif sayı kontrolü
  static String? isPositive(String? value, {String? fieldName}) {
    final numberError = isNumber(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final number = double.parse(value!);
    if (number <= 0) {
      return 'Değer 0\'dan büyük olmalıdır';
    }
    return null;
  }

  // Yaş kontrolü
  static String? isValidAge(String? value) {
    final numberError = isNumber(value, fieldName: 'Yaş');
    if (numberError != null) return numberError;

    final age = int.parse(value!);
    if (age < 10 || age > 120) {
      return 'Yaş 10-120 arasında olmalıdır';
    }
    return null;
  }

  // Boy kontrolü (cm)
  static String? isValidHeight(String? value) {
    final numberError = isNumber(value, fieldName: 'Boy');
    if (numberError != null) return numberError;

    final height = double.parse(value!);
    if (height < 100 || height > 250) {
      return 'Boy 100-250 cm arasında olmalıdır';
    }
    return null;
  }

  // Kilo kontrolü (kg)
  static String? isValidWeight(String? value) {
    final numberError = isNumber(value, fieldName: 'Kilo');
    if (numberError != null) return numberError;

    final weight = double.parse(value!);
    if (weight < 30 || weight > 300) {
      return 'Kilo 30-300 kg arasında olmalıdır';
    }
    return null;
  }

  // Yüzde kontrolü
  static String? isValidPercentage(String? value, {String? fieldName}) {
    final numberError = isNumber(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final percentage = double.parse(value!);
    if (percentage < 0 || percentage > 100) {
      return 'Yüzde 0-100 arasında olmalıdır';
    }
    return null;
  }

  // Tekrar sayısı kontrolü
  static String? isValidReps(String? value) {
    final numberError = isNumber(value, fieldName: 'Tekrar');
    if (numberError != null) return numberError;

    final reps = int.parse(value!);
    if (reps < 1 || reps > 1000) {
      return 'Tekrar sayısı 1-1000 arasında olmalıdır';
    }
    return null;
  }

  // E-posta kontrolü (gelecek için)
  static String? isValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi zorunludur';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi giriniz';
    }
    return null;
  }
}
