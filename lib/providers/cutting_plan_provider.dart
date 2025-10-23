import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/cutting_plan.dart';
import '../models/piece.dart';
import '../services/database_service.dart';

class CuttingPlanProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;
  
  CuttingPlan? _currentPlan;
  List<CuttingPlan> _savedPlans = [];
  
  CuttingPlan? get currentPlan => _currentPlan;
  List<CuttingPlan> get savedPlans => _savedPlans;
  
  // Yeni plan oluştur
  void createNewPlan({String customerName = 'Müşteri'}) {
    _currentPlan = CuttingPlan(
      id: const Uuid().v4(),
      customerName: customerName,
      createdAt: DateTime.now(),
      pieces: [],
    );
    notifyListeners();
  }
  
  // Parça ekle
  void addPiece(double width, double height, bool isBanded, {int quantity = 1}) {
    if (_currentPlan == null) return;
    
    final piece = Piece(
      id: const Uuid().v4(),
      width: width,
      height: height,
      isBanded: isBanded,
      quantity: quantity,
    );
    
    _currentPlan = _currentPlan!.copyWith(
      pieces: [..._currentPlan!.pieces, piece],
    );
    
    notifyListeners();
  }
  
  // Parça güncelle
  void updatePiece(String pieceId, {
    double? width,
    double? height,
    bool? isBanded,
    int? quantity,
  }) {
    if (_currentPlan == null) return;
    
    final updatedPieces = _currentPlan!.pieces.map((piece) {
      if (piece.id == pieceId) {
        return piece.copyWith(
          width: width,
          height: height,
          isBanded: isBanded,
          quantity: quantity,
        );
      }
      return piece;
    }).toList();
    
    _currentPlan = _currentPlan!.copyWith(pieces: updatedPieces);
    notifyListeners();
  }
  
  // Parça sil
  void removePiece(String pieceId) {
    if (_currentPlan == null) return;
    
    _currentPlan = _currentPlan!.copyWith(
      pieces: _currentPlan!.pieces.where((p) => p.id != pieceId).toList(),
    );
    
    notifyListeners();
  }
  
  // Tüm parçaları temizle
  void clearPieces() {
    if (_currentPlan == null) return;
    
    _currentPlan = _currentPlan!.copyWith(pieces: []);
    notifyListeners();
  }
  
  // Müşteri adı güncelle
  void updateCustomerName(String name) {
    if (_currentPlan == null) return;
    
    _currentPlan = _currentPlan!.copyWith(customerName: name);
    notifyListeners();
  }
  
  // Tabaka ölçüleri güncelle
  void updateSheetSize(double width, double height) {
    if (_currentPlan == null) return;
    
    _currentPlan = _currentPlan!.copyWith(
      sheetWidth: width,
      sheetHeight: height,
    );
    notifyListeners();
  }
  
  // Not ekle/güncelle
  void updateNotes(String notes) {
    if (_currentPlan == null) return;
    
    _currentPlan = _currentPlan!.copyWith(notes: notes);
    notifyListeners();
  }
  
  // Planı kaydet
  Future<void> savePlan() async {
    if (_currentPlan == null || _currentPlan!.pieces.isEmpty) return;
    
    await _dbService.createCuttingPlan(_currentPlan!);
    await loadSavedPlans();
    notifyListeners();
  }
  
  // Kaydedilmiş planları yükle
  Future<void> loadSavedPlans() async {
    _savedPlans = await _dbService.getAllCuttingPlans();
    notifyListeners();
  }
  
  // Kaydedilmiş planı yükle
  Future<void> loadPlan(String planId) async {
    final plan = await _dbService.getCuttingPlan(planId);
    if (plan != null) {
      _currentPlan = plan;
      notifyListeners();
    }
  }
  
  // Planı sil
  Future<void> deletePlan(String planId) async {
    await _dbService.deleteCuttingPlan(planId);
    await loadSavedPlans();
    
    if (_currentPlan?.id == planId) {
      _currentPlan = null;
    }
    
    notifyListeners();
  }
  
  // Parçaları sırala (büyükten küçüğe)
  void sortPiecesBySize() {
    if (_currentPlan == null) return;
    
    final sortedPieces = List<Piece>.from(_currentPlan!.pieces)
      ..sort((a, b) => (b.width * b.height).compareTo(a.width * a.height));
    
    _currentPlan = _currentPlan!.copyWith(pieces: sortedPieces);
    notifyListeners();
  }
}

