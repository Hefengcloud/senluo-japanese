// ignore_for_file: prefer_const_declarations

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senluo_japanese_cms/database/grammars/models/grammar_item_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = "senluo.db";
  static const _dbVersion = 1;

  static final _tableGrammar = 'grammar';

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // the table [grammar]
    await db.execute('''
          CREATE TABLE $_tableGrammar (
            id INTEGER PRIMARY KEY, 
            name TEXT,
            level TEXT,
            meaning TEXT,
            conjugation TEXT,
            explanation TEXT,
            example TEXT
           )
          ''');
  }

  Future insertGrammarItem(GrammarItemModel model) async {
    final db = await database;
    try {
      await db.insert(
        _tableGrammar,
        {
          'name': model.name,
          'level': model.level,
          'meaning': model.meaning,
          'conjugation': model.conjugation,
          'explanation': model.explanation,
          'example': model.example,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<GrammarItemModel> loadGrammarItem(int id) async {
    final db = await database;
    try {
      final maps = await db.query(
        _tableGrammar,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return GrammarItemModel.fromMap(maps[0]);
      } else {
        return GrammarItemModel.empty();
      }
    } catch (e) {
      log(e.toString());
    }
    return GrammarItemModel.empty();
  }

  Future<List<GrammarItemModel>> loadGrammarItems() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        _tableGrammar,
        columns: ['id', 'name'],
      );
      return List.generate(
        maps.length,
        (i) => GrammarItemModel.fromMap(maps[i]),
      );
    } catch (e) {
      log(e.toString());
    }

    return [];
  }
}
