import 'dart:convert';

import 'package:path/path.dart';
import 'package:project_anakkos_app/model/db_model/kost_model.dart';
import 'package:sqflite/sqflite.dart';

class KostDatabase {
  static final KostDatabase instance = KostDatabase._init();

  static Database? _database;

  KostDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('kostFav.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableKost ( 
  ${KostFields.id} $idType, 
  ${KostFields.idKost} $integerType,
  ${KostFields.name} $textType,
  ${KostFields.coverImg} $textType,
  ${KostFields.location} $textType,
  ${KostFields.type} $textType,
  ${KostFields.price} $textType
  )
''');
  }

  Future<KostFav> create(KostFav kost) async {
    final db = await instance.database;
    final id = await db.insert(tableKost, kost.toJson());
    return kost.copy(id: id);
  }

  Future<KostFav> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableKost,
      columns: KostFields.values,
      where: '${KostFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KostFav.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<KostFav>> readAll() async {
    final db = await instance.database;
    final result = await db.query(tableKost);
    return result.map((json) => KostFav.fromJson(json)).toList();
  }

  Future<int> update(KostFav kost) async {
    final db = await instance.database;
    return db.update(
      tableKost,
      kost.toJson(),
      where: '${KostFields.id} = ?',
      whereArgs: [kost.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableKost,
      where: '${KostFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
