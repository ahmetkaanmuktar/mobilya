import 'package:flutter_test/flutter_test.dart';
import 'package:muktar_marangoz/models/piece.dart';

void main() {
  group('Piece Model Tests', () {
    test('Piece should be created with correct values', () {
      final piece = Piece(
        id: '1',
        width: 1000,
        height: 2000,
        isBanded: true,
        quantity: 5,
      );

      expect(piece.id, '1');
      expect(piece.width, 1000);
      expect(piece.height, 2000);
      expect(piece.isBanded, true);
      expect(piece.quantity, 5);
    });

    test('Area calculation should be correct', () {
      final piece = Piece(
        id: '1',
        width: 1000,
        height: 2000,
        isBanded: false,
      );

      expect(piece.area, 2.0); // 1000 * 2000 / 1000000 = 2 m²
    });

    test('Total area calculation should include quantity', () {
      final piece = Piece(
        id: '1',
        width: 1000,
        height: 2000,
        isBanded: false,
        quantity: 5,
      );

      expect(piece.totalArea, 10.0); // 2 m² * 5 = 10 m²
    });

    test('toMap should convert piece to map correctly', () {
      final piece = Piece(
        id: '1',
        width: 1000,
        height: 2000,
        isBanded: true,
        quantity: 3,
      );

      final map = piece.toMap();

      expect(map['id'], '1');
      expect(map['width'], 1000);
      expect(map['height'], 2000);
      expect(map['isBanded'], 1);
      expect(map['quantity'], 3);
    });

    test('fromMap should create piece from map correctly', () {
      final map = {
        'id': '2',
        'width': 500.0,
        'height': 1500.0,
        'isBanded': 0,
        'quantity': 2,
      };

      final piece = Piece.fromMap(map);

      expect(piece.id, '2');
      expect(piece.width, 500);
      expect(piece.height, 1500);
      expect(piece.isBanded, false);
      expect(piece.quantity, 2);
    });

    test('copyWith should create new piece with updated values', () {
      final original = Piece(
        id: '1',
        width: 1000,
        height: 2000,
        isBanded: false,
        quantity: 1,
      );

      final updated = original.copyWith(
        width: 1500,
        isBanded: true,
      );

      expect(updated.id, '1');
      expect(updated.width, 1500);
      expect(updated.height, 2000);
      expect(updated.isBanded, true);
      expect(updated.quantity, 1);
    });
  });
}

