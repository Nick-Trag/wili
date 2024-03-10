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
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "name TEXT NOT NULL, "
          "category_id INTEGER NOT NULL, "
          "price REAL NOT NULL DEFAULT 0, "
          "purchased INTEGER NOT NULL DEFAULT 0, " // Actually a bool
          "note TEXT NOT NULL DEFAULT '', "
          "quantity INTEGER NOT NULL DEFAULT 1, "
          "link TEXT NOT NULL DEFAULT '', "
          "image TEXT NOT NULL DEFAULT '', "
          "FOREIGN KEY (category_id) "
            "REFERENCES Categories (id) "
            "ON DELETE CASCADE "
            "ON UPDATE CASCADE"
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
            'name': 'Hobbies',
          }
        );
        await database.insert(
          'Categories',
          {
            'name': 'Other',
          } // TODO: Add emojis and select which categories I want as default
        );
      },
      version: 1,
      onOpen: (database) async {
        // By default, SQLite turns off foreign keys whenever it opens a database. Don't ask me why, it just does. This makes sure they are on
        await database.execute('PRAGMA foreign_keys = ON');
      }
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

  Future<WishlistItem?> getItemById(int id) async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> itemMaps = await db.query(
      'Items',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (itemMaps.isEmpty) {
      return null;
    }

    return WishlistItem(
      id: itemMaps[0]['id'] as int,
      name: itemMaps[0]['name'] as String,
      category: itemMaps[0]['category_id'],
      price: itemMaps[0]['price'] as double,
      purchased: itemMaps[0]['purchased'] == 0 ? false : true,
      note: itemMaps[0]['note'] as String,
      quantity: itemMaps[0]['quantity'] as int,
      link: itemMaps[0]['link'] as String,
      image: itemMaps[0]['image'] as String,
    );
  }

  Future<Map<int, String>> getCategories() async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> categoryMaps = await db.query('Categories');

    return {
      for (var mapItem in categoryMaps) mapItem['id'] : mapItem['name']
    };
  }

  Future<void> addCategory(String name) async {
    final Database db = await initializeDB();

    await db.insert('Categories', {'name': name});
  }

  Future<void> updateCategory(int id, String name) async {
    final Database db = await initializeDB();

    await db.update(
      'Categories',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      'Categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateImage(int id, String imagePath) async {
    final Database db = await initializeDB();

    await db.update(
      'Items',
      {'image': imagePath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearImage(int id) async {
    final Database db = await initializeDB();

    await db.update(
      'Items',
      {'image' : ''},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

