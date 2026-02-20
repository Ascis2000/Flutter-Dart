
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../widgets/movie_card.dart';

/// Pantalla principal que muestra películas populares obtenidas desde TMDB.
/// Soporta:
/// - Paginación infinita (scroll infinito)
/// - Refresco manual con pull-to-refresh
/// - Filtrado por género y año de forma opcional
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Servicio de comunicación con la API externa
  final ApiService _apiService = ApiService();

  /// Servicio de persistencia local usando Hive
  final HiveService _hiveService = HiveService();

  /// Controlador de scroll para detectar cuándo se llega al final
  final ScrollController _scrollController = ScrollController();
  
  /// Página actual de resultados (para paginación)
  int _currentPage = 1;

  /// Flag para indicar si hay más páginas disponibles
  bool _hasMore = true;

  /// Flag para indicar si se está cargando datos
  bool _isLoading = false;

  /// Lista de películas actualmente cargadas en memoria
  final List<Movie> _movies = [];

  /// Filtros seleccionados por el usuario (pueden ser null)
  String? _selectedGenre;
  String? _selectedYear;

  /// Map dinámico de géneros obtenidos desde la API
  Map<String, int> _nameToGenreId = {};
  List<String> _availableGenres = [];

  /// Lista de años dinámicamente del año actual hasta 1910
  final List<String> _availableYears = List.generate(
    DateTime.now().year - 1910 + 1,
    (index) => (DateTime.now().year - index).toString(),
  );

  @override
  void initState() {
    super.initState();
    _loadGenres();
    _fetchMovies();

    /// Listener del scroll:
    /// Si estamos cerca del final y no estamos cargando ni agotamos resultados,
    /// se llama a _fetchMovies() para cargar la siguiente página.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchMovies();
      }
    });
  }

  /// Carga géneros desde la API y genera mapas útiles
  Future<void> _loadGenres() async {
    try {
      final genres = await _apiService.fetchGenres();
      if (mounted) {
        setState(() {
          _nameToGenreId = {for (var e in genres.entries) e.value: e.key};
          _availableGenres = genres.values.toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar géneros: $e')),
        );
      }
    }
  }

  /// Refresco manual (pull-to-refresh)
  Future<void> _refreshMovies() async {
    setState(() {
      _movies.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchMovies();
  }

  /// Obtiene películas desde la API según filtros y paginación
  Future<void> _fetchMovies() async {
    if (!_hasMore) return;
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Obtenemos el ID del género seleccionado (si hay)
      int? genreId;
      if (_selectedGenre != null) {
        genreId = _nameToGenreId[_selectedGenre!];
      }

      final newMovies = await _apiService.fetchMoviesByFilters(
        genreId: genreId, // PASAMOS ID DIRECTAMENTE
        year: _selectedYear,
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          _movies.addAll(newMovies);
          _currentPage++;
          if (newMovies.isEmpty) _hasMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar películas: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Actualiza filtros y reinicia paginación
  void _onFilterChanged({String? genre, String? year}) {
    setState(() {
      _selectedGenre = genre;
      _selectedYear = year;
      _movies.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    _fetchMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshMovies,
        child: Column(
          children: [
            // ==========================
            // FILTROS (Dropdowns)
            // ==========================
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Dropdown Género
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Selecciona Género'),
                      value: _selectedGenre,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Todos los géneros'),
                        ),
                        ..._availableGenres.map((genre) => DropdownMenuItem(
                              value: genre,
                              child: Text(genre),
                            )),
                      ],
                      onChanged: (value) {
                        _onFilterChanged(genre: value, year: _selectedYear);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dropdown Año
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Selecciona Año'),
                      value: _selectedYear,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Todos los años'),
                        ),
                        ..._availableYears.map((year) => DropdownMenuItem(
                              value: year,
                              child: Text(year),
                            )),
                      ],
                      onChanged: (value) {
                        _onFilterChanged(genre: _selectedGenre, year: value);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ==========================
            // GRID DE PELÍCULAS
            // ==========================
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _movies.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _movies.length) {
                    final movie = _movies[index];
                    return MovieCard(
                      movie: movie,
                      hiveService: _hiveService,
                      onAdded: () {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('"${movie.title}" añadido a tu lista'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                      },
                      onRemoved: () {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('"${movie.title}" eliminado de tu lista'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                      },
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}