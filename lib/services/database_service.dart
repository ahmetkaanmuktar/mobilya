import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cutting_plan.dart';
import '../models/piece.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  
  DatabaseService._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('muktar_marangoz.db');
    return _database!;
  }
  
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  
  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    
    await db.execute('''
      CREATE TABLE cutting_plans (
        id $idType,
        customerName $textType,
        createdAt $textType,
        sheetWidth $realType,
        sheetHeight $realType,
        notes TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE pieces (
        id $idType,
        planId $textType,
        width $realType,
        height $realType,
        isBanded $intType,
        quantity $intType,
        FOREIGN KEY (planId) REFERENCES cutting_plans (id) ON DELETE CASCADE
      )
    ''');
  }
  
  Future<String> createCuttingPlan(CuttingPlan plan) async {
    final db = await database;
    
    await db.insert('cutting_plans', plan.toMap());
    
    for (final piece in plan.pieces) {
      await db.insert('pieces', {
        ...piece.toMap(),
        'planId': plan.id,
      });
    }
    
    return plan.id;
  }
  
  Future<List<CuttingPlan>> getAllCuttingPlans() async {
    final db = await database;
    
    final planMaps = await db.query(
      'cutting_plans',
      orderBy: 'createdAt DESC',
    );
    
    List<CuttingPlan> plans = [];
    
    for (final planMap in planMaps) {
      final pieceMaps = await db.query(
        'pieces',
        where: 'planId = ?',
        whereArgs: [planMap['id']],
      );
      
      final pieces = pieceMaps.map((pieceMap) => Piece.fromMap(pieceMap)).toList();
      plans.add(CuttingPlan.fromMap(planMap, pieces));
    }
    
    return plans;
  }
  
  Future<CuttingPlan?> getCuttingPlan(String id) async {
    final db = await database;
    
    final planMaps = await db.query(
      'cutting_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (planMaps.isEmpty) return null;
    
    final pieceMaps = await db.query(
      'pieces',
      where: 'planId = ?',
      whereArgs: [id],
    );
    
    final pieces = pieceMaps.map((pieceMap) => Piece.fromMap(pieceMap)).toList();
    
    return CuttingPlan.fromMap(planMaps.first, pieces);
  }
  
  Future<int> deleteCuttingPlan(String id) async {
    final db = await database;
    
    await db.delete(
      'pieces',
      where: 'planId = ?',
      whereArgs: [id],
    );
    
    return await db.delete(
      'cutting_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

