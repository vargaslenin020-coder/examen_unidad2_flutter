import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'person_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'personas.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute("CREATE TABLE personas(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, apellido TEXT, cedula TEXT, edad INTEGER, ciudad TEXT)");
    });
  }

  Future<int> insert(Person p) async => (await database).insert('personas', p.toMap());
  Future<List<Person>> getAll() async {
    final res = await (await database).query('personas');
    return res.map((map) => Person.fromMap(map)).toList();
  }
  Future<int> delete(int id) async => (await database).delete('personas', where: 'id = ?', whereArgs: [id]);
}