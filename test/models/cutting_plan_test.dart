import 'package:flutter_test/flutter_test.dart';
import 'package:muktar_marangoz/models/cutting_plan.dart';
import 'package:muktar_marangoz/models/piece.dart';

void main() {
  group('CuttingPlan Model Tests', () {
    late List<Piece> testPieces;

    setUp(() {
      testPieces = [
        Piece(
          id: '1',
          width: 1000,
          height: 2000,
          isBanded: false,
          quantity: 2,
        ), // 4 m²
        Piece(
          id: '2',
          width: 500,
          height: 1000,
          isBanded: true,
          quantity: 3,
        ), // 1.5 m²
      ];
    });

    test('CuttingPlan should be created with correct values', () {
      final plan = CuttingPlan(
        id: '1',
        customerName: 'Test Customer',
        createdAt: DateTime(2025, 1, 1),
        pieces: testPieces,
      );

      expect(plan.id, '1');
      expect(plan.customerName, 'Test Customer');
      expect(plan.pieces.length, 2);
    });

    test('Sheet area calculation should be correct', () {
      final plan = CuttingPlan(
        id: '1',
        customerName: 'Test',
        createdAt: DateTime.now(),
        pieces: [],
        sheetWidth: 2800,
        sheetHeight: 2100,
      );

      expect(plan.sheetArea, 5.88); // 2800 * 2100 / 1000000
    });

    test('Total pieces area should sum all pieces', () {
      final plan = CuttingPlan(
        id: '1',
        customerName: 'Test',
        createdAt: DateTime.now(),
        pieces: testPieces,
      );

      expect(plan.totalPiecesArea, 5.5); // 4 + 1.5 = 5.5 m²
    });

    test('Required sheets should be calculated correctly', () {
      final plan = CuttingPlan(
        id: '1',
        customerName: 'Test',
        createdAt: DateTime.now(),
        pieces: testPieces,
        sheetWidth: 2800,
        sheetHeight: 2100,
      );

      // Total: 5.5 m², Sheet: 5.88 m²
      // Required: ceil(5.5 / 5.88) = 1
      expect(plan.requiredSheets, 1);
    });

    test('Waste area should be calculated correctly', () {
      final plan = CuttingPlan(
        id: '1',
        customerName: 'Test',
        createdAt: DateTime.now(),
        pieces: testPieces,
        sheetWidth: 2800,
        sheetHeight: 2100,
      );

      // Waste: (1 * 5.88) - 5.5 = 0.38 m²
      expect(plan.wasteArea, closeTo(0.38, 0.01));
    });

    test('Waste percentage should be calculated correctly', () {
      final plan = CuttingPlan(
        id: '1',
        customerName: 'Test',
        createdAt: DateTime.now(),
        pieces: testPieces,
        sheetWidth: 2800,
        sheetHeight: 2100,
      );

      // Percentage: (0.38 / 5.88) * 100 ≈ 6.46%
      expect(plan.wastePercentage, closeTo(6.46, 0.5));
    });

    test('copyWith should create new plan with updated values', () {
      final original = CuttingPlan(
        id: '1',
        customerName: 'Original',
        createdAt: DateTime(2025, 1, 1),
        pieces: testPieces,
      );

      final updated = original.copyWith(
        customerName: 'Updated',
      );

      expect(updated.customerName, 'Updated');
      expect(updated.id, '1');
      expect(updated.pieces, testPieces);
    });
  });
}

