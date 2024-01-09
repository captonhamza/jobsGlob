import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/cityModel.dart';
import '../Models/countryModel.dart';
import '../Models/getAllCategoryModel.dart';

class DatabaseHelper {
  Database? db;
  static String databaseName = "jobGlobal.db";
  static int databaseVersion = 1;

  static String table = 'profileInfo';
  static String table2 = 'allCategoryTable';
  static String table3 = 'adminProfileInfo';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await init();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        personaProfileImage Text,
        personFirstName Text,
        personLastName Text,
        personCategoryType Text,
         personGenderType Text,
        personDateOfBirth Text,
        personEmail Text,
        personPhoneNo Text,
        personallInfoValid Text,
        address Text,
        city Text,
        country Text,
        postCode Text,
        town Text,
        nationality Text,
        addressInfoValid Text,
        emergencyName Text,
        emergencyRealtion Text,
        emergencyPhoneNo Text,
       emergencyInfoValid Text,
        passportImage Text,
        UtilityImage Text,
        ResidentImage Text,
         documentInfoValid Text,
         visaRewquired Text,
         uk_driving_licence Text,
         resumeFile Text,
         shortIntro Text,
        insuranceNo Text,
        utrNo Text,
      
        badgeImage Text,
        badgeType Text,
        badgeNo Text,
        expiryDate Text,
         badgeInfoValid Text
      )
    ''');

    // sortCode Text,
    //   accountNo Text,
    //   accountName Text,
    //    bankInfoValid Text,

    await db.execute('''
      CREATE TABLE  $table2 (
        id INTEGER PRIMARY KEY ,
        name Text
      )
    ''');

    await db.execute('''
      CREATE TABLE  $table3 (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
        companyLogo Text,
        companyName Text,
        companyEmail Text,
        companyPhone Text,
         companyWebsiteUrl Text,
          companyTeamSize Text,
        companyDiscribtion Text,
        companyRegisterNo Text,
        companyCountry Text,
        companyCity Text,
        companyAddress
      )
    ''');
  }

  // Profile Data Base CURD Operations

  Future<int> saveData(Map<String, dynamic> data) async {
    db = await instance.database;
    return await db!.insert(
      "profileInfo",
      data,
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    db = await instance.database;
    return await db!.query("profileInfo");
  }

  Future<int> updateData(int? id, Map<String, dynamic> updatedData) async {
    db = await instance.database;
    // Check if the 'itemdetailsData' key exists and if it is not already encoded

    try {
      return await db!.update(
        "profileInfo",
        updatedData,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }

// Curd Company funcations

  Future<int> ComapnySaveData(Map<String, dynamic> data) async {
    db = await instance.database;
    return await db!.insert(
      "profileInfo",
      data,
    );
  }

  Future<List<Map<String, dynamic>>> CompanyGetData() async {
    db = await instance.database;
    return await db!.query("profileInfo");
  }

  Future<int> CompanyUpdateData(
      int? id, Map<String, dynamic> updatedData) async {
    db = await instance.database;
    // Check if the 'itemdetailsData' key exists and if it is not already encoded

    try {
      return await db!.update(
        "profileInfo",
        updatedData,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }

  // All Category Data Base CURD Operations

  Future<int> allCategorysaveData(AllCategoryData data) async {
    db = await instance.database;
    int id = data.id!;

    // Check if a record with the same id exists in the database
    final existingRecord = await db!.query(
      table2,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (existingRecord.isNotEmpty) {
      // If a record with the same id exists, update it
      return await db!.update(
        table2,
        data.toJson(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      // If no record with the same id exists, insert a new record
      return await db!.insert(
        table2,
        data.toJson(),
      );
    }
  }

  Future<List<AllCategoryData>> allCategorygetData() async {
    final List<Map<String, dynamic>> results = await db!.query(table2);

    // Create a list of AllCategoryData by mapping the results
    List<AllCategoryData> data = results.map((Map<String, dynamic> map) {
      return AllCategoryData(
        id: map['id'] as int,
        name: map['name'].toString() as String,
      );
    }).toList();

    return data;
  }

  Future<int> allCategoryupdateData(
      int? id, Map<String, dynamic> updatedData) async {
    db = await instance.database;
    // Check if the 'itemdetailsData' key exists and if it is not already encoded

    try {
      return await db!.update(
        table2,
        updatedData,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteData(int? id) async {
    db = await instance.database;
    return await db!.delete(
      "profileInfo",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> resetDatabase() async {
    // Step 1: Open the database
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'jobGlobal.db');

      await databaseFactory.deleteDatabase(path);

      final file = File(path);
      await file.delete();
      final newDatabase = await openDatabase(path);
      await newDatabase.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
