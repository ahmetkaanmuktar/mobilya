class AppConstants {
  // Tabaka Ölçüleri
  static const double defaultSheetWidth = 2800.0; // mm
  static const double defaultSheetHeight = 2100.0; // mm
  
  // Minimum ve Maximum Değerler
  static const double minPieceSize = 50.0; // mm
  static const double maxPieceSize = 3000.0; // mm
  
  // Uygulama Bilgileri
  static const String appName = 'Muktar Marangoz';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'MDF Kesim Hesaplama ve Fatura Uygulaması';
  
  // Varsayılan Değerler
  static const String defaultCustomerName = 'Müşteri';
  
  // Renk Kodları (Hex)
  static const String primaryColor = '#8B4513';
  static const String secondaryColor = '#D2691E';
  static const String lightColor = '#F5E6D3';
  
  // PDF Ayarları
  static const String pdfTitle = 'MUKTAR MARANGOZ';
  static const String pdfSubtitle = 'MDF Kesim Planı';
  
  // Tarih Formatı
  static const String dateFormat = 'dd/MM/yyyy HH:mm';
  static const String dateOnlyFormat = 'dd/MM/yyyy';
  
  // Decimal Precision
  static const int areaPrecision = 3; // m² için
  static const int percentPrecision = 1; // % için
  
  // WhatsApp Mesaj Şablonu
  static String getWhatsAppMessage({
    required String customerName,
    required int requiredSheets,
    required int totalPieces,
    required String totalArea,
    required String wasteArea,
    required String wastePercentage,
  }) {
    return '''
🪵 *MUKTAR MARANGOZ*
*Müşteri:* $customerName

📋 *Kesim Özeti:*
• Gerekli Tabaka: *$requiredSheets Adet*
• Toplam Parça: *$totalPieces Adet*
• Toplam Alan: *$totalArea m²*
• Artık Alan: *$wasteArea m²*
• Artık Oranı: *$wastePercentage%*

Detaylı kesim listesi PDF'te mevcuttur.
    ''';
  }
}

