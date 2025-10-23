import 'piece.dart';

class CuttingPlan {
  final String id;
  final String customerName;
  final DateTime createdAt;
  final List<Piece> pieces;
  final double sheetWidth; // Tabaka eni (mm)
  final double sheetHeight; // Tabaka boyu (mm)
  final String? notes;
  
  CuttingPlan({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.pieces,
    this.sheetWidth = 2800,
    this.sheetHeight = 2100,
    this.notes,
  });
  
  // Tabaka alanı (m²)
  double get sheetArea => (sheetWidth * sheetHeight) / 1000000;
  
  // Toplam parça alanı (m²)
  double get totalPiecesArea {
    return pieces.fold(0.0, (sum, piece) => sum + piece.totalArea);
  }
  
  // Gerekli tabaka sayısı
  int get requiredSheets {
    return (totalPiecesArea / sheetArea).ceil();
  }
  
  // Artık alan (m²)
  double get wasteArea {
    return (requiredSheets * sheetArea) - totalPiecesArea;
  }
  
  // Artık yüzdesi
  double get wastePercentage {
    if (requiredSheets == 0) return 0;
    return (wasteArea / (requiredSheets * sheetArea)) * 100;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'createdAt': createdAt.toIso8601String(),
      'sheetWidth': sheetWidth,
      'sheetHeight': sheetHeight,
      'notes': notes,
    };
  }
  
  factory CuttingPlan.fromMap(Map<String, dynamic> map, List<Piece> pieces) {
    return CuttingPlan(
      id: map['id'] as String,
      customerName: map['customerName'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      pieces: pieces,
      sheetWidth: map['sheetWidth'] as double? ?? 2800,
      sheetHeight: map['sheetHeight'] as double? ?? 2100,
      notes: map['notes'] as String?,
    );
  }
  
  CuttingPlan copyWith({
    String? id,
    String? customerName,
    DateTime? createdAt,
    List<Piece>? pieces,
    double? sheetWidth,
    double? sheetHeight,
    String? notes,
  }) {
    return CuttingPlan(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      pieces: pieces ?? this.pieces,
      sheetWidth: sheetWidth ?? this.sheetWidth,
      sheetHeight: sheetHeight ?? this.sheetHeight,
      notes: notes ?? this.notes,
    );
  }
}

