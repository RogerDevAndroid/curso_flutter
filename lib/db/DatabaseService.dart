import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:movies_app/models/movie.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE movies (
          id INTEGER PRIMARY KEY,
          title TEXT,
          posterPath TEXT,
          backdropPath TEXT,
          overview TEXT,
          releaseDate TEXT,
          voteAverage REAL,
          genero TEXT
        )
      ''');
      },
    );
  }


//CREATE
  Future<void> addMovieToWatchList(Movie movie) async {
    final db = await database;
    await db.insert(
      'movies',
      movie.toMap(), // Asegúrate de que Movie tenga un método toMap()
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
//DELETE
  Future<void> removeMovieFromWatchList(int id) async {
    final db = await database;
    await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //UPDATE
  /*Future<void> updateMovieFromWatchList(int id,String title) async {
    final db = await database;
    await db.update(
      'movies',
      title.toM,
      where: 'id = ?',
      whereArgs: [id],
    );
  }*/
//READ
  Future<List<Movie>> getWatchListMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    //final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * from movies where voteAverage >1',null);

    return List.generate(maps.length, (i) {
      return Movie.fromMapSave(maps[i]); // Asegúrate de que Movie tenga un método fromMapSave()
    });
  }
}