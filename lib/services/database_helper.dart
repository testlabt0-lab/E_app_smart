import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('efa_pro.db');
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

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE custom_words (
  id $idType,
  word $textType,
  translation $textType,
  usage $textType,
  example $textType,
  emoji $textType,
  ipa $textType,
  movieQuote $textType,
  partOfSpeech $textType,
  v2 $textType,
  v3 $textType,
  synonyms $textType,
  antonyms $textType,
  categoryId $textType,
  subcategoryId $textType,
  levelId $textType
)
''');

    await db.execute('''
CREATE TABLE srs_progress (
  wordId $idType,
  interval $integerType,
  nextReviewDate $textType
)
''');

    await db.execute('''
CREATE TABLE mistakes (
  wordId $idType
)
''');

    await db.execute('''
CREATE TABLE grammar_srs (
  lessonId $idType,
  interval $integerType,
  nextReviewDate $textType
)
''');
  }

  // --- Custom Words Operations ---
  Future<void> createCustomWord(Word word) async {
    final db = await instance.database;
    final map = word.toJson();
    map['synonyms'] = map['synonyms'].join(',');
    map['antonyms'] = map['antonyms'].join(',');
    await db.insert('custom_words', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Word>> readAllCustomWords() async {
    final db = await instance.database;
    final result = await db.query('custom_words');
    return result.map((json) {
      final modJson = Map<String, dynamic>.from(json);
      modJson['synonyms'] = (modJson['synonyms'] as String).isEmpty ? [] : (modJson['synonyms'] as String).split(',');
      modJson['antonyms'] = (modJson['antonyms'] as String).isEmpty ? [] : (modJson['antonyms'] as String).split(',');
      return Word.fromJson(modJson);
    }).toList();
  }

  Future<void> deleteCustomWord(String id) async {
    final db = await instance.database;
    await db.delete('custom_words', where: 'id = ?', whereArgs: [id]);
  }

  // --- SRS Operations ---
  Future<void> upsertSrs(SavedItem item) async {
    final db = await instance.database;
    await db.insert('srs_progress', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SavedItem>> readAllSrs() async {
    final db = await instance.database;
    final result = await db.query('srs_progress');
    return result.map((json) => SavedItem.fromJson(json)).toList();
  }

  Future<void> deleteSrs(String wordId) async {
    final db = await instance.database;
    await db.delete('srs_progress', where: 'wordId = ?', whereArgs: [wordId]);
  }

  // --- Mistakes Operations ---
  Future<void> addMistake(String wordId) async {
    final db = await instance.database;
    await db.insert('mistakes', {'wordId': wordId}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<String>> readAllMistakes() async {
    final db = await instance.database;
    final result = await db.query('mistakes');
    return result.map((json) => json['wordId'] as String).toList();
  }

  Future<void> removeMistake(String wordId) async {
    final db = await instance.database;
    await db.delete('mistakes', where: 'wordId = ?', whereArgs: [wordId]);
  }

  // --- Grammar SRS ---
  Future<void> upsertGrammarSrs(SavedItem item) async {
    final db = await instance.database;
    await db.insert('grammar_srs', {'lessonId': item.wordId, 'interval': item.interval, 'nextReviewDate': item.nextReviewDate.toIso8601String()}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SavedItem>> readAllGrammarSrs() async {
    final db = await instance.database;
    final result = await db.query('grammar_srs');
    return result.map((json) => SavedItem.fromJson({'wordId': json['lessonId'], 'interval': json['interval'], 'nextReviewDate': json['nextReviewDate']})).toList();
  }
}
