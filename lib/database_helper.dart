import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // ======================
  // DATABASE
  // ======================
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();

    return _database!;
  }

  // ======================
  // INIT DATABASE
  // ======================
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'coffeshop.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // ======================
  // CREATE TABLE
  // ======================
  Future _createDB(Database db, int version) async {
    await db.execute('''

      CREATE TABLE products(

        id INTEGER PRIMARY KEY AUTOINCREMENT,

        name TEXT NOT NULL,

        price INTEGER NOT NULL,

        description TEXT NOT NULL,

        image TEXT NOT NULL

      )

    ''');
  }

  // ======================
  // CREATE PRODUCT
  // ======================
  Future<int> insertProduct(Map<String, dynamic> data) async {
    final db = await instance.database;

    return await db.insert('products', data);
  }

  // ======================
  // READ PRODUCTS
  // ======================
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await instance.database;

    return await db.query('products', orderBy: 'id DESC');
  }

  // ======================
  // UPDATE PRODUCT
  // ======================
  Future<int> updateProduct(int id, Map<String, dynamic> data) async {
    final db = await instance.database;

    return await db.update('products', data, where: 'id = ?', whereArgs: [id]);
  }

  // ======================
  // DELETE PRODUCT
  // ======================
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;

    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
