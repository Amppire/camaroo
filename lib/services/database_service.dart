import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/photo.dart';
import '../models/album.dart';
import '../utils/constants.dart';

/// Service for local database storage
class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create photos table
    await db.execute('''
      CREATE TABLE photos (
        id TEXT PRIMARY KEY,
        path TEXT NOT NULL,
        dateTaken TEXT NOT NULL,
        albumId TEXT,
        latitude REAL,
        longitude REAL,
        metadata TEXT,
        tags TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');

    // Create albums table
    await db.execute('''
      CREATE TABLE albums (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        coverPhotoPath TEXT,
        photoCount INTEGER DEFAULT 0
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_photos_albumId ON photos(albumId)');
    await db.execute('CREATE INDEX idx_photos_dateTaken ON photos(dateTaken)');
    await db.execute('CREATE INDEX idx_photos_isFavorite ON photos(isFavorite)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  // Photo CRUD operations
  Future<int> insertPhoto(Photo photo) async {
    final db = await database;
    return await db.insert('photos', photo.toJson());
  }

  Future<List<Photo>> getAllPhotos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      orderBy: 'dateTaken DESC',
    );
    return List.generate(maps.length, (i) => Photo.fromJson(maps[i]));
  }

  Future<List<Photo>> getPhotosByAlbum(String albumId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'albumId = ?',
      whereArgs: [albumId],
      orderBy: 'dateTaken DESC',
    );
    return List.generate(maps.length, (i) => Photo.fromJson(maps[i]));
  }

  Future<List<Photo>> getFavoritePhotos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'dateTaken DESC',
    );
    return List.generate(maps.length, (i) => Photo.fromJson(maps[i]));
  }

  Future<int> updatePhoto(Photo photo) async {
    final db = await database;
    return await db.update(
      'photos',
      photo.toJson(),
      where: 'id = ?',
      whereArgs: [photo.id],
    );
  }

  Future<int> deletePhoto(String photoId) async {
    final db = await database;
    return await db.delete(
      'photos',
      where: 'id = ?',
      whereArgs: [photoId],
    );
  }

  // Album CRUD operations
  Future<int> insertAlbum(Album album) async {
    final db = await database;
    return await db.insert('albums', album.toJson());
  }

  Future<List<Album>> getAllAlbums() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'albums',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Album.fromJson(maps[i]));
  }

  Future<Album?> getAlbum(String albumId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'albums',
      where: 'id = ?',
      whereArgs: [albumId],
    );
    if (maps.isEmpty) return null;
    return Album.fromJson(maps.first);
  }

  Future<int> updateAlbum(Album album) async {
    final db = await database;
    return await db.update(
      'albums',
      album.toJson(),
      where: 'id = ?',
      whereArgs: [album.id],
    );
  }

  Future<int> deleteAlbum(String albumId) async {
    final db = await database;
    return await db.delete(
      'albums',
      where: 'id = ?',
      whereArgs: [albumId],
    );
  }

  // Search operations
  Future<List<Photo>> searchPhotos(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'tags LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'dateTaken DESC',
    );
    return List.generate(maps.length, (i) => Photo.fromJson(maps[i]));
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
