class Piece {
  final String id;
  final double width; // En (mm - içeride cm olarak gösterilir)
  final double height; // Boy (mm - içeride cm olarak gösterilir)
  final bool isBanded; // Bantlı mı?
  final int quantity; // Adet
  
  Piece({
    required this.id,
    required this.width,
    required this.height,
    required this.isBanded,
    this.quantity = 1,
  });
  
  // Alan hesaplama (m²)
  double get area => (width * height) / 1000000;
  
  // Toplam alan (adet dahil)
  double get totalArea => area * quantity;
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'isBanded': isBanded ? 1 : 0,
      'quantity': quantity,
    };
  }
  
  factory Piece.fromMap(Map<String, dynamic> map) {
    return Piece(
      id: map['id'] as String,
      width: map['width'] as double,
      height: map['height'] as double,
      isBanded: (map['isBanded'] as int) == 1,
      quantity: map['quantity'] as int? ?? 1,
    );
  }
  
  Piece copyWith({
    String? id,
    double? width,
    double? height,
    bool? isBanded,
    int? quantity,
  }) {
    return Piece(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      isBanded: isBanded ?? this.isBanded,
      quantity: quantity ?? this.quantity,
    );
  }
}

