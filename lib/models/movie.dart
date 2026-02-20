
import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterUrl;

  @HiveField(3)
  final String year;

  @HiveField(4)
  String status;

  @HiveField(5)
  List<String> genres; // NUEVO CAMPO

  // Mapa para traducir IDs de TMDB a nombres legibles
  static const Map<int, String> genreMap = {
    28: 'Action',
    35: 'Comedy',
    18: 'Drama',
    27: 'Horror',
    878: 'Sci-Fi',
  };

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.year,
    this.status = 'Pendiente',
    this.genres = const [],
  });

  // Convierte JSON de The Movie DB a Movie
  factory Movie.fromJson(Map<String, dynamic> json) {
    List<int> genreIds = json['genre_ids'] != null
        ? List<int>.from(json['genre_ids'])
        : [];
    List<String> genreNames = genreIds.map((id) => genreMap[id] ?? 'Unknown').toList();

    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      year: json['release_date'] != null && json['release_date'].isNotEmpty
          ? json['release_date'].split('-')[0]
          : '',
      genres: genreNames,
    );
  }
}
