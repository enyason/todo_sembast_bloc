import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

//singleton class for db
class AppDatabase {


  //create single instance of AppDatabase via the private constructor
  static final AppDatabase _singleton = AppDatabase._();

  //getter for class instance
  static AppDatabase get instance => _singleton;

//  Completer<Database> _dbOpenCompleter;

  //database instance
  Database _database;

  //private constructor
  AppDatabase._();



  Future<Database> get database  async{

    //open db if db is null
    if (_database == null) {
      _database = await _openDatabase();
    }

    //return already opened db
    return _database;
  }

   Future<Database> _openDatabase() async {

    //get application directory
    final directory = await getApplicationDocumentsDirectory();

    //construct path
    final dbPath = join(directory.path, "todo.db");

    //open database
    final db = await databaseFactoryIo.openDatabase(dbPath);
    return db;
  }
}
