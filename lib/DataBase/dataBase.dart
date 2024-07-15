// ignore_for_file: missing_return, prefer_typing_uninitialized_variables, file_names
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
    var res;
    final db = await SqlLiteDb.db();
    for (var item in model!) {
      res = db.insert(
        "Name", item.toMap(), //toMap()
        conflictAlgorithm: sql.ConflictAlgorithm
            .ignore, //ignores conflicts due to duplicate entries
      );
    }
    //  await db.rawQuery('delete from Resources');
    return res;
  }

  Future<int> createFavouritesItem({NameModel? model}) async {
    final db = await SqlLiteDb.favdb();
    // int updateCount = await db
    //     .update("Name", model!.toMap(), where: 'id = ?', whereArgs: [model.id]);
    var res = db.insert(
      "Favourites", model!.toMap(), //toMap()
      conflictAlgorithm: sql.ConflictAlgorithm
          .ignore, //ignores conflicts due to duplicate entries
    );
    // res = db.rawUpdate(''' UPDATE Name
    // SET
    //   EnglishName =?,
    //   EnglishMeaning =?,
    //   EnglishReligion =?,
    //   EnglishLuckyNumber =?,
    //   EnglishLuckyDay =?,
    //   EnglishLuckyColor =?,
    //   EnglishLuckyStones  =?,
    //   EnglishLanguage  =?,
    //   EnglishLuckyMetals =?,
    //   UrduName =?,
    //   UrduMeaning =?,
    //   UrduReligion =?,
    //   UrduLuckyNumber =?,
    //   UrduLuckyDay =?,
    //   UrduLuckyColor =?,
    //   UrduLuckyStones  =?,
    //   UrduLanguage  =?,
    //   UrduLuckyMetals =?,
    //   Gender = ?
    //   isFavourite =?,
    // WHERE id = ?''', [
    //   model!.englishLanguage,
    //   model.englishLuckyColor,
    //   model.urduLuckyDay,
    //   model.englishMeaning,
    //   model.englishLuckyMetals,
    //   model.englishLuckyNumber,
    //   model.englishLuckyStones,
    //   model.englishName,
    //   model.englishReligion,
    //   model.urduLanguage,
    //   model.urduLuckyColor,
    //   model.urduLuckyDay,
    //   model.urduMeaning,
    //   model.urduLuckyMetals,
    //   model.urduLuckyNumber,
    //   model.urduLuckyStones,
    //   model.urduName,
    //   model.urduReligion,
    //   model.id
    // ]);
    // //  await db.rawQuery('delete from Resources');
    return res;
  }

  Future<List<NameModel>> getItems() async {
    List<NameModel> list = [];
    final db = await SqlLiteDb.db();
    List<Map<String, dynamic>> data = await db.rawQuery("select * from Name");
    NameModel model;
    for (int i = 0; i < data.length; i++) {
      model = NameModel();
      //  model.id = data[i]["id"].toString();
      model.englishName = data[i]["EnglishName"].toString();
      model.englishMeaning = data[i]["EnglishMeaning"].toString();
      model.englishReligion = data[i]["EnglishReligion"].toString();
      model.englishLuckyNumber = data[i]["EnglishLuckyNumber"].toString();
      model.englishLuckyDay = data[i]["EnglishLuckyDay"].toString();
      model.englishLuckyColor = data[i]["EnglishLuckyColor"].toString();
      model.englishLuckyStones = data[i]["EnglishLuckyStones"].toString();
      model.englishLanguage = data[i]["EnglishLanguage"].toString();
      model.gender = data[i]["Gender"].toString();
      model.englishLuckyMetals = data[i]["EnglishLuckyMetals"].toString();
      model.urduName = data[i]["UrduName"].toString();
      model.urduMeaning = data[i]["UrduMeaning"].toString();
      model.urduReligion = data[i]["UrduReligion"].toString();
      model.urduLuckyNumber = data[i]["UrduLuckyNumber"].toString();
      model.urduLuckyDay = data[i]["UrduLuckyDay"].toString();
      model.urduLuckyColor = data[i]["UrduLuckyColor"].toString();
      model.urduLuckyStones = data[i]["UrduLuckyStones"].toString();
      model.urduLanguage = data[i]["UrduLanguage"].toString();
      model.urduLuckyMetals = data[i]["UrduLuckyMetals"].toString();
      model.isFavourite = data[i]["isFavourite"].toString();
      list.add(model);
    }
    return list;
  }

  Future<List<NameModel>> getFavouritesItems() async {
    List<NameModel> list = [];
    final db = await SqlLiteDb.favdb();
    List<Map<String, dynamic>> data =
        await db.rawQuery("select * from Favourites");
    NameModel model;
    for (int i = 0; i < data.length; i++) {
      model = NameModel();
      //   model.id = data[i]["id"].toString();
      model.englishName = data[i]["EnglishName"].toString();
      model.englishMeaning = data[i]["EnglishMeaning"].toString();
      model.englishReligion = data[i]["EnglishReligion"].toString();
      model.englishLuckyNumber = data[i]["EnglishLuckyNumber"].toString();
      model.englishLuckyDay = data[i]["EnglishLuckyDay"].toString();
      model.englishLuckyColor = data[i]["EnglishLuckyColor"].toString();
      model.englishLuckyStones = data[i]["EnglishLuckyStones"].toString();
      model.englishLanguage = data[i]["EnglishLanguage"].toString();
      model.gender = data[i]["Gender"].toString();
      model.englishLuckyMetals = data[i]["EnglishLuckyMetals"].toString();
      model.urduName = data[i]["UrduName"].toString();
      model.urduMeaning = data[i]["UrduMeaning"].toString();
      model.urduReligion = data[i]["UrduReligion"].toString();
      model.urduLuckyNumber = data[i]["UrduLuckyNumber"].toString();
      model.urduLuckyDay = data[i]["UrduLuckyDay"].toString();
      model.urduLuckyColor = data[i]["UrduLuckyColor"].toString();
      model.urduLuckyStones = data[i]["UrduLuckyStones"].toString();
      model.urduLanguage = data[i]["UrduLanguage"].toString();
      model.urduLuckyMetals = data[i]["UrduLuckyMetals"].toString();
      model.isFavourite = data[i]["isFavourite"].toString();
      list.add(model);
    }
    return list;
  }
}
