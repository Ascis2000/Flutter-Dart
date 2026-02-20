
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/data.dart';
import '../models/movie.dart';

/// Servicio encargado de comunicarse con The Movie DB (TMDB) API.
/// Proporciona métodos para obtener información de películas.
/// Se puede ampliar en el futuro con detalles, búsquedas, etc.
class ApiService {

  /// URL base de la API TMDB
  final String _baseUrl = 'https://api.themoviedb.org/3';

  /// API Key versión 3 de TMDB.
  /// Permite autenticar y realizar llamadas a la API
  final String _apiKey = tmdbApiKey;

  /// Obtiene la lista de películas populares.
  ///
  /// Parámetros:
  /// - [page]: número de página a solicitar (para paginación)
  ///
  /// Retorna una lista de objetos Movie mapeados desde JSON.
  /// Lanza excepción si la respuesta no es exitosa.
  Future<List<Movie>> fetchPopularMovies(int page) async {
    final url = Uri.parse(
        '$_baseUrl/movie/popular?api_key=$_apiKey&language=es-ES&page=$page');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar películas: ${response.statusCode}');
    }
  }

  /// Obtiene todos los géneros de películas que maneja TMDB.
  /// Devuelve un Map<int, String> donde la key es el genreId y el value es el nombre legible.
  Future<Map<int, String>> fetchGenres() async {
    final url = Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey&language=es-ES');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> genres = data['genres'];

      // Convertimos a Map<int, String> para poder usarlo fácilmente
      final Map<int, String> genreMap = {
        for (var g in genres)
          g['id'] as int: g['name'] as String
      };

      return genreMap;
    } else {
      throw Exception('Error al cargar géneros: ${response.statusCode}');
    }
  }

  /// Obtiene películas filtradas por género y/o año directamente desde TMDB
  ///
  /// Parámetros:
  /// - [genreId]: ID del género TMDB
  /// - [year]: año de estreno ('2026', '2025', etc.)
  /// - [page]: número de página para paginación
  ///
  /// Retorna una lista de objetos Movie mapeados desde JSON.
  /// Lanza excepción si la respuesta no es exitosa.
  Future<List<Movie>> fetchMoviesByFilters({
    int? genreId,
    String? year,
    int page = 1,
  }) async {

    // Construimos parámetros de consulta
    final Map<String, String> query = {
      'api_key': _apiKey,
      'language': 'es-ES',
      'page': page.toString(),
    };

    // Filtrado por año
    if (year != null) {
      query['primary_release_year'] = year;
    }

    // Filtrado por género
    if (genreId != null) {
      query['with_genres'] = genreId.toString();
    }

    final url = Uri.https('api.themoviedb.org', '/3/discover/movie', query);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al cargar películas con filtros: ${response.statusCode}');
    }
  }
}