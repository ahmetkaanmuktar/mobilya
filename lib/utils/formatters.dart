import 'package:intl/intl.dart';

class Formatters {
  // Alan formatı (m²)
  static String formatArea(double area, {int precision = 3}) {
    return area.toStringAsFixed(precision);
  }
  
  // Yüzde formatı
  static String formatPercentage(double percentage, {int precision = 1}) {
    return percentage.toStringAsFixed(precision);
  }
  
  // Tarih formatı
  static String formatDate(DateTime date, {String? pattern}) {
    final formatter = DateFormat(pattern ?? 'dd/MM/yyyy HH:mm', 'tr_TR');
    return formatter.format(date);
  }
  
  // Sadece tarih (saat olmadan)
  static String formatDateOnly(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'tr_TR');
    return formatter.format(date);
  }
  
  // Sadece saat
  static String formatTimeOnly(DateTime date) {
    final formatter = DateFormat('HH:mm', 'tr_TR');
    return formatter.format(date);
  }
  
  // Ölçü formatı (cm)
  static String formatDimension(double dimension) {
    // mm'den cm'ye çevir (10'a böl)
    return '${(dimension / 10).toStringAsFixed(1)} cm';
  }
  
  // Para formatı (opsiyonel, gelecek özellikler için)
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
  
  // Büyük sayılar için formatı
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'tr_TR');
    return formatter.format(number);
  }
}

