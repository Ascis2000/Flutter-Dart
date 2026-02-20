
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';

/// Servicio singleton que maneja la persistencia de películas usando Hive.
/// Permite añadir, eliminar, actualizar y consultar películas de la lista personal.
class HiveService {
  // Instancia privada para patrón singleton
  static final HiveService _instance = HiveService._internal();

  /// Factory constructor para siempre devolver la misma instancia
  factory HiveService() => _instance;

  // Constructor interno privado
  HiveService._internal();

  /// Caja Hive donde se guardan las películas
  Box<Movie>? _box;

  /// Inicializa Hive y abre la caja.
  /// Debe llamarse en main() antes de usar HiveService.
  static Future<void> init() async {
    // Inicializa Hive
    await Hive.initFlutter();

    // Registra adaptador de Movie
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieAdapter());
    }

    // Abre la caja si no está abierta
    await Hive.openBox<Movie>('my_movies');
  }

  /// Asegura que la caja esté lista antes de usarla
  Box<Movie> get _safeBox {
    if (_box == null) {
      _box = Hive.box<Movie>('my_movies');
    }
    return _box!;
  }

  /// Devuelve todas las películas guardadas en la lista personal
  List<Movie> getMovies() => _safeBox.values.toList();

  /// Permite escuchar cambios en la caja de Hive
  /// Ideal para actualizar automáticamente UI mediante ValueListenableBuilder
  ValueListenable<Box<Movie>> listenable() => _safeBox.listenable();

  /// Comprueba si una película ya está guardada en Hive según su ID
  bool isMovieSaved(int id) => _safeBox.containsKey(id);

  /// Añade una película a la lista personal si aún no existe
  /// [movie]: objeto Movie a guardar
  Future<void> addMovie(Movie movie) async {
    if (!_safeBox.containsKey(movie.id)) {
      await _safeBox.put(movie.id, movie);
    }
  }

  /// Elimina una película de la lista personal por su ID
  Future<void> removeMovie(int id) async {
    await _safeBox.delete(id);
  }

  /// Actualiza la información de una película existente en Hive
  /// Si no existía previamente, la crea
  Future<void> updateMovie(Movie movie) async {
    await _safeBox.put(movie.id, movie);
  }

  /// Borra todas las películas guardadas en la lista personal
  Future<void> clearMovies() async {
    await _safeBox.clear();
  }
}