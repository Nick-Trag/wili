import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wili/classes/item.dart';

class SQLiteService {

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
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
        ")");
        // Insert some default categories
        await database.insert(
          'Categories',
          {
            'name': 'Tech',
          }
        );
        await database.insert(
          'Categories',
          {
            'name': 'Clothes',
          }
        );
        await database.insert(
          'Categories',
          {
            'name': 'Hobby',
          }
        );
        await database.insert(
          'Categories',
          {
            'name': 'Misc.',
          }
        );
      },
      version: 1,
    );
  }

  Future<void> addItem(WishlistItem item) async {
    // I don't like using this method every time, but this is how literally everyone does it, so I suppose this is the intended use
    final Database db = await initializeDB();

    await db.insert('Items', item.toMap());
  }

  Future<void> updateItem(WishlistItem item) async {
    final Database db = await initializeDB();

    await db.update(
      'Items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      'Items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<WishlistItem>> getAllItems() async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> itemMaps = await db.query('Items');

    //Convert to list of items
    return List.generate(itemMaps.length, (i) => WishlistItem(
      id: itemMaps[i]['id'] as int,
      name: itemMaps[i]['name'] as String,
      category: itemMaps[i]['category_id'],
      price: itemMaps[i]['price'] as double,
      purchased: itemMaps[i]['purchased'] == 0 ? false : true,
      note: itemMaps[i]['note'] as String,
      quantity: itemMaps[i]['quantity'] as int,
      link: itemMaps[i]['link'] as String,
      image: itemMaps[i]['image'] as String,
      )
    );
  }

  Future<Map<int, String>> getCategories() async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> categoryMaps = await db.query('Categories');

    return {
      for (var mapItem in categoryMaps) mapItem['id'] : mapItem['name']
    };
  }
}

