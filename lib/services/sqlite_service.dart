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
            "price REAL,"
            "purchased INTEGER," // Actually a bool
            "note TEXT,"
            "quantity INTEGER,"
            "link TEXT,"
            "image TEXT"
          ")"); // TODO: Full schema + categories table + categories as foreign key
      },
      version: 0,
    );
  }
}

