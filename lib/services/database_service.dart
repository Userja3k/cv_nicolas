import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/membre_famille.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static void initializeFfiIfRequired() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> _initDatabase() async {
    initializeFfiIfRequired();

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cv_app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Table Utilisateurs (Authentification)
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Insertion de l'utilisateur par défaut: Admin / admin123
    await db.insert('utilisateurs', {
      'username': 'Admin',
      'password': 'admin123',
    });

    // 2. Table Membres de la famille (CRUD)
    await db.execute('''
      CREATE TABLE membres_famille (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        lien TEXT,
        prof TEXT NOT NULL,
        image TEXT
      )
    ''');

    // Insertion des membres initiaux
    final membresInitiaux = [
      {
        'nom': 'Donatien BADESIRE',
        'lien': 'Père',
        'prof': "Agent de l'État",
        'image': 'assets/images/pere.jpg',
      },
      {
        'nom': 'Pascaline NZIGIRE',
        'lien': 'Mère',
        'prof': 'Commerçante',
        'image': 'assets/images/mere.jpg',
      },
      {
        'nom': 'Nicole Ansima',
        'lien': 'Soeur',
        'prof': 'Élève finaliste',
        'image': 'assets/images/soeur.jpg',
      },
    ];

    for (var m in membresInitiaux) {
      await db.insert('membres_famille', m);
    }
  }

  // --- Authentification ---
  Future<bool> authentifier(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'utilisateurs',
      where: 'username = ? AND password = ?',
      whereArgs: [username.trim(), password],
    );
    return res.isNotEmpty;
  }

  // --- CRUD Membres de la famille ---
  Future<List<MembreFamille>> getMembres() async {
    final db = await database;
    final res = await db.query('membres_famille', orderBy: 'id ASC');
    return res.map((e) => MembreFamille.fromMap(e)).toList();
  }

  Future<int> ajouterMembre(MembreFamille membre) async {
    final db = await database;
    return await db.insert('membres_famille', membre.toMap());
  }

  Future<int> modifierMembre(MembreFamille membre) async {
    final db = await database;
    return await db.update(
      'membres_famille',
      membre.toMap(),
      where: 'id = ?',
      whereArgs: [membre.id],
    );
  }

  Future<int> supprimerMembre(int id) async {
    final db = await database;
    return await db.delete(
      'membres_famille',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
