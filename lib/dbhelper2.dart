import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:apps/pic.dart';
class DBhelper{
  static Database _db;
  static const  String ID='id';
  static const String NAME='phtoname';
  static const String TABLE='photos_table';
  static const String DB_NAME='photos.db';
  	Future<Database> get db async {
		if (_db == null) {
			_db = await initDB();
		}
		return _db;

	}
  initDB() async{
    io.Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'photos.db';
		var db = await openDatabase(path, version: 1, onCreate: _createdb);
		return db;
  }
_createdb(Database db,int version)async{
await db.execute('CREATE TABLE $TABLE($ID INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT )');

}
Future<Photo> save(Photo photo)async{
  var dbclient=await db;
  photo.id=await dbclient.insert(TABLE, photo.toMap());
  return photo;
}
Future<List<Photo>> getPhotos() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<Photo> photos = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
       photos.add(Photo.fromMap(maps[i]));
      }
    }
    return photos;
  }
  Future close()async{
    var dbClient=await db;
    dbClient.close();
  }
  
}