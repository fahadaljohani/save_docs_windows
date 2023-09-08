import 'package:path/path.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static const String tableFullNameTo = 'documentss.db';
  static const String tableToName = 'documentsTo';
  static const String tableInName = 'documentsIn';
  static const int version = 1;
  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), tableFullNameTo), version: version,
        onCreate: (db, version) async {
      print('-----On Create Called-----');
      await db.execute('''
CREATE TABLE $tableToName ('id' INTEGER PRIMARY KEY AUTOINCREMENT,'to' TEXT NOT NULL,'from' TEXT NOT NULL,'description' TEXT NOT NULL,'attachNumber' INTEGER NOT NULL,'createdAt' DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,'replyFor' INTEGER,'saveTo' TEXT,'documentID' TEXT,'imageUrl' TEXT);
''');
      await db.execute('''
CREATE TABLE $tableInName ('id' INTEGER PRIMARY KEY AUTOINCREMENT,'to' TEXT NOT NULL,'from' TEXT NOT NULL,'description' TEXT NOT NULL,'attachNumber' INTEGER NOT NULL,'createdAt' DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,'replyFor' INTEGER,'saveTo' TEXT,'documentID' TEXT,'imageUrl' TEXT);
''');
    });
  }

  static Future<int> addDocument(DocumentModel doc) async {
    final db = await getDatabase();
    if (doc.replyFor != null) {
      await db.rawUpdate('UPDATE $tableInName SET replyFor = ? WHERE id = ?', [doc.replyFor, doc.replyFor]);
    }
    return await db.insert(tableToName, doc.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addToInDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.insert(tableInName, doc.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.update(tableToName, doc.toMap(),
        where: 'id = ?', whereArgs: [doc.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateToInDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.update(tableInName, doc.toMap(),
        where: 'id = ?', whereArgs: [doc.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.delete(tableToName, where: 'id = ?', whereArgs: [doc.id]);
  }

  static Future<int> deleteInDocument(DocumentModel doc) async {
    final db = await getDatabase();
    return await db.delete(tableInName, where: 'id = ?', whereArgs: [doc.id]);
  }

  static Future<List<DocumentModel>?> getAllDocumnets() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> docs = await db.query(tableToName, orderBy: 'createdAt DESC');
    if (docs.isEmpty) return null;
    return List.generate(docs.length, (index) => DocumentModel.fromMap(docs[index]));
  }

  static Future<List<DocumentModel>?> getAllInDocumnets() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> docs = await db.query(tableInName, orderBy: 'createdAt DESC');
    if (docs.isEmpty) return null;
    return List.generate(docs.length, (index) => DocumentModel.fromMap(docs[index]));
  }

  static Future<List<DocumentModel>?> getRepliedDocs() async {
    final db = await getDatabase();
//     final sql = '''
// SELECT * FROM $tableToName
// INNER JOIN $tableInName ON $tableInName.id = $tableToName.replyFor
// WHERE $tableInName.id == $tableToName.replyFor
// ORDER BY createdAt DESC;
// ''';
//     print(sql);
//     final result = await db.rawQuery(sql);
//     if (result.isNotEmpty) {
//       return List.generate(result.length, (index) => DocumentModel.fromMap(result[index]));
//     } else {
//       return [];
//     }
    final results = await db.query(tableInName, orderBy: 'createdAt DESC', limit: 100);
    List<DocumentModel>? repliedDocs;
    if (results.isNotEmpty) {
      for (var docIn in results) {
        final docModel = DocumentModel.fromMap(docIn);
        final docTo = await db.query(tableToName, where: 'replyFor = ?', whereArgs: [docModel.id], limit: 1);
        docTo.isNotEmpty ? repliedDocs!.add(DocumentModel.fromMap(docTo.first)) : null;
      }
    }
    return repliedDocs ?? null;
  }

  static Future<List<DocumentModel>?> getNotRepliedDocs() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> docs = await db.query(tableInName, orderBy: 'createdAt DESC', where: 'replyFor != ""');
    if (docs.isEmpty) return null;
    return List.generate(docs.length, (index) => DocumentModel.fromMap(docs[index]));
  }

  static Future<List<DocumentModel>?> getDocumentsWaitingToReply() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> docs = await db.query(tableInName, orderBy: 'createdAt DESC', where: 'replyFor is NULL');
    if (docs.isEmpty) return null;
    return List.generate(docs.length, (index) => DocumentModel.fromMap(docs[index]));
  }

  static Future<int> dropTable() async {
    final db = await getDatabase();
    return await db.delete(tableToName);
  }

  static Future<int> dropInTable() async {
    final db = await getDatabase();
    return await db.delete(tableInName);
  }
}
