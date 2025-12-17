import 'package:intl/intl.dart';

class DateFormatter {
  // Tarih formatları
  static final dayMonthYear = DateFormat('dd.MM.yyyy');
  static final dayMonth = DateFormat('dd MMM', 'tr_TR');
  static final monthYear = DateFormat('MMMM yyyy', 'tr_TR');
  static final time = DateFormat('HH:mm');
  static final dateTime = DateFormat('dd.MM.yyyy HH:mm');

  // Tarih formatlama fonksiyonları
  static String formatDate(DateTime date) {
    return dayMonthYear.format(date);
  }

  static String formatDayMonth(DateTime date) {
    return dayMonth.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return monthYear.format(date);
  }

  static String formatTime(DateTime date) {
    return time.format(date);
  }

  static String formatDateTime(DateTime date) {
    return dateTime.format(date);
  }

  // Göreceli zaman (örn: "2 gün önce")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years yıl önce';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Şimdi';
    }
  }

  // Bugün, dün, tarih
  static String formatSmartDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Bugün';
    } else if (dateOnly == yesterday) {
      return 'Dün';
    } else if (now.difference(date).inDays < 7) {
      return '${now.difference(date).inDays} gün önce';
    } else {
      return formatDate(date);
    }
  }
}
