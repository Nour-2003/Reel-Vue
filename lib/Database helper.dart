
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
List<Map> movies = [];
class Database_helper{
  static final Database_helper instance = Database_helper._init();

  static Database? db;
  Database_helper._init();
  final _favoriteNotifier = ValueNotifier<List<Map>>([]);
  ValueListenable<List<Map>> get favoriteNotifier =>
      _favoriteNotifier;
   void createDatabase() async {
    db = await openDatabase(
      'fav.db',
      onCreate: (db, version) async {
        print("Database is created");
        await db
            .execute(
            '  CREATE TABLE favs (id INTEGER PRIMARY KEY, title TEXT ,image TEXT )')
            .then((value) {
          print("table is created");
        }).catchError((error) {
          print("Error when creating table");
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db).then((value) {
          movies = value;
          print(movies);
        });
        print("Database is opened");
      },
      version: 1,
    );
  }

  Future<void> insertToDatabase({required int id,required String title,required String image}) async {
    await db?.transaction((txn) async {
      try {
        txn.rawInsert(
            'INSERT INTO favs(id,title,image) VALUES("$id","$title","$image")');
        print('Inserted Successfully');
      } catch (error) {
        print('Error inserting into database: $error');
      }
    });
  }
  Future<bool?> isFavorite(int productId) async {
   // final db = instance._db;
    final result = await db?.query(
      'favs',
      where: ' Id = ?',
      whereArgs: [productId],
    );
    return result?.isNotEmpty;
  }
Future<List<Map>> getDataFromDatabase(database)async{
  movies =  await database.rawQuery('SELECT * FROM favs');
  _favoriteNotifier.value = movies;
  return movies;
  }
  Future<int> deleteFromDatabase(int id) async{
    late var result;
     try {
    result = await db?.rawDelete('DELETE FROM favs WHERE id = $id');
      print('Deleted Successfully');
    } catch (e) {
      print('Error deleting item: $e');
    }
    return result;
  }
}