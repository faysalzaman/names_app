// ignore_for_file: missing_return, prefer_typing_uninitialized_variables, file_names
import 'dart:developer';

import 'package:names_app/Model/names_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlLiteDb {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE Name(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
      EnglishName TEXT,
      EnglishMeaning TEXT,
      EnglishReligion TEXT,
      EnglishLuckyNumber TEXT,
      EnglishLuckyDay TEXT,
      EnglishLuckyColor TEXT,
      EnglishLuckyStones  TEXT,
      EnglishLanguage  TEXT,
      EnglishLuckyMetals TEXT, 
      EnglishFamousPerson TEXT, 
      EnglishDescription TEXT, 
      EnglishKnownFor TEXT, 
      EnglishOccopation TEXT,
      Gender TEXT,
      UrduName TEXT,
      UrduMeaning TEXT,
      UrduReligion TEXT,
      UrduLuckyNumber TEXT,
      UrduLuckyDay TEXT,
      UrduLuckyColor TEXT,
      UrduLuckyStones  TEXT,
      UrduLanguage  TEXT,
      UrduLuckyMetals TEXT, 
      UrduFamousPerson TEXT, 
      UrduDescription TEXT, 
      UrduKnownFor TEXT, 
      UrduOccopation TEXT, 
      isFavourite TEXT
      )
      """);
  }

  static Future<void> createFavouritesTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE Favourites(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
      EnglishName TEXT,
      EnglishMeaning TEXT,
      EnglishReligion TEXT,
      EnglishLuckyNumber TEXT,
      EnglishLuckyDay TEXT,
      EnglishLuckyColor TEXT,
      EnglishLuckyStones  TEXT,
      EnglishLanguage  TEXT,
      EnglishLuckyMetals TEXT, 
      EnglishFamousPerson TEXT, 
      EnglishDescription TEXT, 
      EnglishKnownFor TEXT, 
      EnglishOccopation TEXT,
      Gender TEXT,
      UrduName TEXT,
      UrduMeaning TEXT,
      UrduReligion TEXT,
      UrduLuckyNumber TEXT,
      UrduLuckyDay TEXT,
      UrduLuckyColor TEXT,
      UrduLuckyStones  TEXT,
      UrduLanguage  TEXT,
      UrduLuckyMetals TEXT, 
      UrduFamousPerson TEXT, 
      UrduDescription TEXT, 
      UrduKnownFor TEXT, 
      UrduOccopation TEXT,
      isFavourite TEXT 
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'Names.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<sql.Database> favdb() async {
    return sql.openDatabase(
      'Favourites.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createFavouritesTables(database);
      },
    );
  }

  Future<int> createItem({List<NameModel>? model}) async {
    int res = 0;
    final db = await SqlLiteDb.db();
    for (var item in model!) {
      try {
        res = await db.insert(
          "Name",
          item.toMap(),
          conflictAlgorithm: sql.ConflictAlgorithm.ignore,
        );
        print("Inserted item with id: $res");
      } catch (e) {
        print("Error inserting item: $e");
      }
    }
    return res;
  }

  Future<int> createFavouritesItem({NameModel? model}) async {
    if (model == null) return 0;

    final db = await SqlLiteDb.favdb();
    try {
      var map = model.toMap();
      // Remove fields not present in the Favourites table
      map.remove("EnglishFamousPerson");
      map.remove("UrduFamousPerson");

      var res = await db.insert(
        "Favourites",
        map,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore,
      );
      return res;
    } catch (e) {
      print('Error inserting favourite: $e');
      return 0;
    }
  }

  Future<List<NameModel>> getItems() async {
    List<NameModel> list = [];
    final db = await SqlLiteDb.db();
    List<Map<String, dynamic>> data = await db.rawQuery("select * from Name");
    NameModel model;
    for (int i = 0; i < data.length; i++) {
      model = NameModel(
        id: data[i]["id"].toString(),
        englishName: data[i]["EnglishName"].toString(),
        englishMeaning: data[i]["EnglishMeaning"].toString(),
        englishReligion: data[i]["EnglishReligion"].toString(),
        englishLuckyDay: data[i]["EnglishLuckyDay"].toString(),
        englishLuckyColor: data[i]["EnglishLuckyColor"].toString(),
        englishLuckyStones: data[i]["EnglishLuckyStones"].toString(),
        englishLanguage: data[i]["EnglishLanguage"].toString(),
        englishLuckyMetals: data[i]["EnglishLuckyMetals"].toString(),
        englishFamousPerson: data[i]["EnglishFamousPerson"].toString(),
        englishDescription: data[i]["EnglishDescription"].toString(),
        englishKnownFor: data[i]["EnglishKnownFor"].toString(),
        englishOccopation: data[i]["EnglishOccopation"].toString(),
        gender: data[i]["Gender"].toString(),
        urduName: data[i]["UrduName"].toString(),
        urduMeaning: data[i]["UrduMeaning"].toString(),
        urduReligion: data[i]["UrduReligion"].toString(),
        urduLuckyNumber: data[i]["UrduLuckyNumber"].toString(),
        urduLuckyDay: data[i]["UrduLuckyDay"].toString(),
        urduLuckyColor: data[i]["UrduLuckyColor"].toString(),
        urduLuckyStones: data[i]["UrduLuckyStones"].toString(),
        urduLanguage: data[i]["UrduLanguage"].toString(),
        urduLuckyMetals: data[i]["UrduLuckyMetals"].toString(),
        urduFamousPerson: data[i]["UrduFamousPerson"].toString(),
        urduDescription: data[i]["UrduDescription"].toString(),
        urduKnownFor: data[i]["UrduKnownFor"].toString(),
        urduOccopation: data[i]["UrduOccopation"].toString(),
        isFavourite: data[i]["isFavourite"].toString(),
      );

      list.add(model);
    }
    return list;
  }

  Future<List<NameModel>> getFavouritesItems() async {
    List<NameModel> list = [];
    final db = await SqlLiteDb.favdb();
    List<Map<String, dynamic>> data =
        await db.rawQuery("select * from Favourites");
    log(data.toString());
    NameModel model;
    for (int i = 0; i < data.length; i++) {
      model = NameModel(
        id: data[i]["id"].toString(),
        englishName: data[i]["EnglishName"].toString(),
        englishMeaning: data[i]["EnglishMeaning"].toString(),
        englishReligion: data[i]["EnglishReligion"].toString(),
        englishLuckyDay: data[i]["EnglishLuckyDay"].toString(),
        englishLuckyColor: data[i]["EnglishLuckyColor"].toString(),
        englishLuckyStones: data[i]["EnglishLuckyStones"].toString(),
        englishLanguage: data[i]["EnglishLanguage"].toString(),
        englishLuckyMetals: data[i]["EnglishLuckyMetals"].toString(),
        englishFamousPerson: data[i]["EnglishFamousPerson"].toString(),
        englishDescription: data[i]["EnglishDescription"].toString(),
        englishKnownFor: data[i]["EnglishKnownFor"].toString(),
        englishOccopation: data[i]["EnglishOccopation"].toString(),
        gender: data[i]["Gender"].toString(),
        urduName: data[i]["UrduName"].toString(),
        urduMeaning: data[i]["UrduMeaning"].toString(),
        urduReligion: data[i]["UrduReligion"].toString(),
        urduLuckyNumber: data[i]["UrduLuckyNumber"].toString(),
        urduLuckyDay: data[i]["UrduLuckyDay"].toString(),
        urduLuckyColor: data[i]["UrduLuckyColor"].toString(),
        urduLuckyStones: data[i]["UrduLuckyStones"].toString(),
        urduLanguage: data[i]["UrduLanguage"].toString(),
        urduLuckyMetals: data[i]["UrduLuckyMetals"].toString(),
        urduFamousPerson: data[i]["UrduFamousPerson"].toString(),
        urduDescription: data[i]["UrduDescription"].toString(),
        urduKnownFor: data[i]["UrduKnownFor"].toString(),
        urduOccopation: data[i]["UrduOccopation"].toString(),
        isFavourite: data[i]["isFavourite"].toString(),
      );

      list.add(model);
    }
    return list;
  }
}
