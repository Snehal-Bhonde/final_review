import 'package:path/path.dart';
import 'package:final_review/UserModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepository {
  Database?_database;
  static final DatabaseRepository instance = DatabaseRepository
      ._init(); // our class will always have one instane only to make sure the database is only one
  DatabaseRepository._init();


  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("user_formdb.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
create table ${AppConst.tableName} ( 
  ${AppConst.uid} integer primary key autoincrement, 
  ${AppConst.firstName} text not null,
   ${AppConst.lastName} text not null,
   ${AppConst.mobNo} integer not null,
   ${AppConst.email} text not null,
   ${AppConst.is_upload} integer not null)
''');
  }

  Future<void> insert({required UserForm userForm}) async {
    try {
      final db = await database;
      db.insert(AppConst.tableName, userForm.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<UserForm>> getAllTodos() async {
    final db = await instance.database;

    final result = await db.query(AppConst.tableName);

    return result.map((json) => UserForm.fromJson(json)).toList();
  }

  Future<void> delete(int id) async {
    try {
      final db = await instance.database;
      await db.delete(
        AppConst.tableName,
        where: '${AppConst.uid} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteAll() async {
    try {
      final db = await instance.database;
      await db.execute(
          "delete from "+ AppConst.tableName
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> update(UserForm userForm) async {
    try {
      final db = await instance.database;
      db.update(
        AppConst.tableName,
        userForm.toMap(),
        where: '${AppConst.uid} = ?',
        whereArgs: [userForm.userId],
      );
    } catch (e) {
      print("update failed");
      print(e.toString());
    }
  }

}
class AppConst {
  static const String uid = 'userId';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String mobNo = 'mobNo';
  static const String email = 'email';
  static const String is_upload = 'is_upload';
  static const String tableName = 'UserFormTable';
}