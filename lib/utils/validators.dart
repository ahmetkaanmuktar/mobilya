import 'constants.dart';

class Validators {
  // Parça ölçü validasyonu
  static String? validatePieceSize(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName giriniz';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Geçerli bir sayı giriniz';
    }
    
    if (number < AppConstants.minPieceSize) {
      return '$fieldName minimum ${AppConstants.minPieceSize} mm olmalıdır';
    }
    
    if (number > AppConstants.maxPieceSize) {
      return '$fieldName maximum ${AppConstants.maxPieceSize} mm olmalıdır';
    }
    
    return null;
  }
  
  // Adet validasyonu
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Adet giriniz';
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'Geçerli bir sayı giriniz';
    }
    
    if (number < 1) {
      return 'Adet en az 1 olmalıdır';
    }
    
    if (number > 1000) {
      return 'Adet maksimum 1000 olabilir';
    }
    
    return null;
  }
  
  // Müşteri adı validasyonu
  static String? validateCustomerName(String? value) {
    if (value == null || value.isEmpty) {
      return null; // İsteğe bağlı
    }
    
    if (value.length < 2) {
      return 'Müşteri adı en az 2 karakter olmalıdır';
    }
    
    if (value.length > 50) {
      return 'Müşteri adı maksimum 50 karakter olabilir';
    }
    
    return null;
  }
  
  // Genel sayı validasyonu
  static String? validateNumber(String? value, {
    required String fieldName,
    double? min,
    double? max,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName giriniz';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Geçerli bir sayı giriniz';
    }
    
    if (min != null && number < min) {
      return '$fieldName minimum $min olmalıdır';
    }
    
    if (max != null && number > max) {
      return '$fieldName maximum $max olmalıdır';
    }
    
    return null;
  }
}

