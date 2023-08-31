import 'package:path/path.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static const String tableFullNameTo = 'documents.db';
  static const String tableToName = 'documentsTo';
  static const String tableInName = 'documentsIn';
  static const int version = 1;
  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), tableFullNameTo), version: version,
        onCreate: (db, version) async {
      print('-----On Create Called-----');
      await db.execute('''
CREATE TABLE $tableToName ('id' INTEGER PRIMARY KEY AUTOINCREMENT,'to' TEXT NOT NULL,'from' TEXT NOT NULL,'description' TEXT NOT NULL,'attachNumber' INTEGER NOT NULL,'createdAt' DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,'replyFor' INTEGER,'saveTo' TEXT,'documentID' TEXT);
''');
      await db.execute('''
CREATE TABLE $tableInName ('id' INTEGER PRIMARY KEY AUTOINCREMENT,'to' TEXT NOT NULL,'from' TEXT NOT NULL,'description' TEXT NOT NULL,'attachNumber' INTEGER NOT NULL,'createdAt' DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,'replyFor' INTEGER,'saveTo' TEXT,'documentID' TEXT);
''');
    });
  }

  static Future<int> addDocument(DocumentModel doc) async {
    final db = await getDatabase();
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

  static Future<List<DocumentModel>> getRepliedDocs() async {
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
    final List<DocumentModel> repliedDocs = [];
    if (results.isNotEmpty) {
      for (var docIn in results) {
        final docModel = DocumentModel.fromMap(docIn);
        print('----docModel---');
        print(docModel);
        final docTo = await db.query(tableToName, where: 'replyFor = ?', whereArgs: [docModel.id], limit: 1);
        repliedDocs.add(DocumentModel.fromMap(docTo.first));
      }
    }
    print('----repliedDocs----');
    print(repliedDocs);
    return repliedDocs;
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
