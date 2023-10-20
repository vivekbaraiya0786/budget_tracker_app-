import 'dart:typed_data';

import 'package:budget_tracker_app/modals/category_model.dart';
import 'package:budget_tracker_app/modals/spending_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper dbHelper = DBHelper._();

  //todo: initialize db
  static Database? db;

  Future initDB() async {
    //get location for db
    String dbLocation = await getDatabasesPath();

    //join a path for your  db to that location
    String path = join(dbLocation, "bta.db");

    // create a db ==> create a table
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String query =
            "CREATE TABLE IF NOT EXISTS categories (category_id INTEGER PRIMARY KEY AUTOINCREMENT,category_name TEXT NOT NULL,category_image BLOB);";
        await db.execute(query);

        String spendingTableQuery =
            "CREATE TABLE IF NOT EXISTS spending (spending_id INTEGER PRIMARY KEY AUTOINCREMENT,spending_desc TEXT NOT NULL,spending_amount NUMERIC NOT NULL,spending_mode TEXT NOT NULL,spending_type TEXT,spending_date TEXT,spending_time TEXT,spending_category INTEGER NOT NULL);";
        await db.execute(spendingTableQuery);
      },
    );
  }

  //todo: insert category

  // Future<int> insertCategory({required String cat_name,Uint8List? img})async{
  //   await initDB();
  //
  //   String query = "INSERT INTO categories(category_name) VALUES('Bills');";
  //
  //   int res = await db!.rawInsert(query);
  //
  //   return res;
  // }

  // Future<int> insertCategory({required String cat_name, Uint8List? img}) async {
  //   await initDB();
  //
  //   String query = "INSERT INTO categories(category_name) VALUES(?);";
  //   List args = [cat_name];
  //   int res = await db!.rawInsert(query, args);
  //
  //   return res;
  // }


  // Future<int> insertCategory({required String cat_name, Uint8List? img}) async {
  //   await initDB();
  //
  //   String query = "INSERT INTO categories(category_name,category_image) VALUES(?,?);";
  //   List args = [cat_name,img];
  //   int res = await db!.rawInsert(query, args); //return pk => inserted record's id
  //
  //   return res;
  // }

    //categories insert table
  Future<int> insertCategory({required CategoryModel data}) async {
    await initDB();

    String query = "INSERT INTO categories(category_name,category_image) VALUES(?,?);";
    List args = [
      data.categoryName,
      data.categoryImage,
    ];
    int res = await db!.rawInsert(query, args); //return pk => inserted record's id

    return res;
  }

  //spending table

  Future<int> insertspenging({required SpendingModel data}) async {
    await initDB();

    String query = "INSERT INTO spending(spending_desc,spending_amount,spending_mode,spending_type,spending_date,spending_time,spending_category) VALUES(?,?,?,?,?,?,?);";
    List args = [
    data.spendingDesc,
    data.spendingAmount,
    data.spendingMode,
    data.spendingType,
    data.spendingDate,
    data.spendingTime,
    data.spendingCategory,
    ];
    int res = await db!.rawInsert(query, args); //return pk => inserted record's id

    return res;
  }

  //todo: fetch categories
  // Future<List<Map<String, dynamic>>> fetchALlCategories()async{
  //   await initDB();
  //   String query = "SELECT * FROM categories;";
  //     List<Map<String, dynamic>> res =await db!.rawQuery(query);  //List<Map<String, dynamic>>
  //     return res;
  //   }

  Future<List<CategoryModel>> fetchALlCategories()async{
    await initDB();
    String query = "SELECT * FROM categories;";
    List<Map<String, dynamic>> res =await db!.rawQuery(query);  //List<Map<String, dynamic>>

      List<CategoryModel> allcategory =  res.map((e) => CategoryModel.fromMap(data: e)).toList();
      return allcategory;
  }

  Future<List<SpendingModel>> fetchALlSpending()async{
    await initDB();
    String query = "SELECT * FROM spending;";
    List<Map<String, dynamic>> res =await db!.rawQuery(query);  //List<Map<String, dynamic>>

    List<SpendingModel> allspending =  res.map((e) => SpendingModel.fromMap(data: e)).toList();
    return allspending;
  }


    //todo: delete categories

      Future<int>deleteCategory({required int id})async{
              await initDB();
              String query = "DELETE FROM categories WHERE category_id=?;";
              List args = [id];
              int res = await db!.rawDelete(query,args);
              return res;
      }

  Future<int> updateCategory({required int categoryId, required String catName, Uint8List? img}) async {
    await initDB();

    String query = "UPDATE categories SET category_name=?, category_image=? WHERE category_id=?;";
    List args = [catName, img, categoryId];
    int res = await db!.rawUpdate(query, args); //returns total no. of updated records' count
    return res;
  }

  //
  // Future<List<Map<String, dynamic>>> fetchSearchCategories({required String data})async{
  //   await initDB();
  //   String query = "SELECT * FROM categories WHERE category_name LIKE '%$data%';";
  //   List<Map<String, dynamic>> res= await db!.rawQuery(query);
  //   return res;
  // }


  //category search
  Future<List<CategoryModel>> fetchSearchCategories({required String data})async{
    await initDB();
    String query = "SELECT * FROM categories WHERE category_name LIKE '%$data%';";
    List<Map<String, dynamic>> res= await db!.rawQuery(query);

    List<CategoryModel> allcategory =  res.map((e) => CategoryModel.fromMap(data: e)).toList();
    return allcategory;
  }

  //spending search
  Future<List<SpendingModel>> fetchSearchspending({required String data})async{
    await initDB();
    String query = "SELECT * FROM spending WHERE spending_desc LIKE '%$data%';";
    List<Map<String, dynamic>> res= await db!.rawQuery(query);

    List<SpendingModel> allcategory =  res.map((e) => SpendingModel.fromMap(data: e)).toList();
    return allcategory;
  }



  Future<List<CategoryModel>> fetchSearchCategory({required int id})async{
    await initDB();
    String query = "SELECT * FROM categories WHERE category_id=?;";

    List args = [id];
    List<Map<String, dynamic>> res= await db!.rawQuery(query,args);

    List<CategoryModel> searchedCategory =  res.map((e) => CategoryModel.fromMap(data: e)).toList();
    return searchedCategory;
  }

  Future<int>deleteSpending({required int id})async{
    await initDB();
    String query = "DELETE FROM spending WHERE spending_id=?;";
    List args = [id];
    int res = await db!.rawDelete(query,args);
    return res;
  }

  Future<int> updateSpanding({required SpendingModel spending, required int id}) async {
    await initDB();

    String query = "UPDATE spending SET spending_desc=?, spending_amount=?,spending_mode=?, spending_type=?, spending_date=?,spending_time=?, spending_category=? ,WHERE category_id=?;";
    List args = [
      spending.spendingDesc,
      spending.spendingAmount,
      spending.spendingMode,
      spending.spendingType,
      spending.spendingDate,
      spending.spendingTime,
      spending.spendingCategory,
    ];
    int res = await db!.rawUpdate(query, args); //returns total no. of updated records' count
    return res;
  }

}
