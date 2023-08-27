import 'package:path/path.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static const String tableFullName = 'docsFile.db';
  static const String tableName = 'docsFile';
  static const int version = 1;
  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), tableFullName), version: version, onCreate: (db, version) async {
      print('-----On Create Call-----');
      return await db.execute('''
CREATE TABLE $tableName ('id' INTEGER PRIMARY KEY AUTOINCREMENT,'to' TEXT NOT NULL,'from' TEXT NOT NULL,'description' TEXT NOT NULL,'attachNumber' INTEGER NOT NULL,'createdAt' DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,'replyFor' INTEGER,'saveTo' TEXT);
''');
    });
  }

  static Future<int> addDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.insert(tableName, doc.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.update(tableName, doc.toMap(),
        where: 'id = ?', whereArgs: [doc.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [doc.id]);
  }

  static Future<List<DocumentModel>?> getAllDocumnets() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> docs = await db.query(tableName, orderBy: 'createdAt DESC');
    if (docs.isEmpty) return null;
    return List.generate(docs.length, (index) => DocumentModel.fromMap(docs[index]));
  }

  static Future<int> dropTable() async {
    final db = await getDatabase();
    return await db.delete(tableName);
  }
}
