// services/local_storage_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorageService {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'nutrition_app.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables for offline data
        await db.execute('''
          CREATE TABLE daily_logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            food_id INTEGER NOT NULL,
            quantity REAL NOT NULL,
            synced INTEGER DEFAULT 0
          )
        ''');
        
        await db.execute('''
          CREATE TABLE foods(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            calories_per_100g REAL NOT NULL,
            protein_per_100g REAL NOT NULL,
            carbs_per_100g REAL NOT NULL,
            fat_per_100g REAL NOT NULL
          )
        ''');
      },
    );
  }
  
  // Save food entry locally
  Future<void> saveFoodEntry(String date, int foodId, double quantity) async {
    final db = await database;
    await db.insert('daily_logs', {
      'date': date,
      'food_id': foodId,
      'quantity': quantity,
      'synced': 0,
    });
  }
  
  // Get unsynced entries
  Future<List<Map<String, dynamic>>> getUnsyncedEntries() async {
    final db = await database;
    return await db.query('daily_logs', where: 'synced = ?', whereArgs: [0]);
  }
  
  // Mark entries as synced
  Future<void> markAsSynced(List<int> ids) async {
    final db = await database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update('daily_logs', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit();
  }
}