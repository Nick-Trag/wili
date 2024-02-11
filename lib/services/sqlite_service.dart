import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE Items("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL,"
          "category TEXT NOT NULL,"
          "price REAL NOT NULL DEFAULT 0,"
          "purchased INTEGER NOT NULL DEFAULT 0," // Actually a bool
          "note TEXT NOT NULL DEFAULT '',"
          "quantity INTEGER NOT NULL DEFAULT 1,"
          "link TEXT NOT NULL DEFAULT '',"
          "image TEXT NOT NULL DEFAULT ''"
        ")"); // TODO: Full schema + categories table + categories as foreign key
      },
      version: 0,
    );
  }
}

