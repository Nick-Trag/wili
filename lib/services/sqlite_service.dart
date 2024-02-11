import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wili/classes/item.dart';

class SQLiteService {

  late final Database database;

  Future<void> initializeDB() async {
    String path = await getDatabasesPath();

    database = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE Categories("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL"
        ")");
        await database.execute("CREATE TABLE Items("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL,"
          "category_id INTEGER NOT NULL,"
          "price REAL NOT NULL DEFAULT 0,"
          "purchased INTEGER NOT NULL DEFAULT 0," // Actually a bool
          "note TEXT NOT NULL DEFAULT '',"
          "quantity INTEGER NOT NULL DEFAULT 1,"
          "link TEXT NOT NULL DEFAULT '',"
          "image TEXT NOT NULL DEFAULT '',"
          "FOREIGN KEY (category_id)"
            "REFERENCES Categories (id)"
            "ON DELETE SET DEFAULT" // Currently there is no default, so this should not even work
        ")"); // TODO: Full schema + categories table + categories as foreign key
      },
      version: 0,
    );
  }

  Future<void> addItem(WishlistItem item) async {
    await database.insert('Items', item.toMap());
  }
}

