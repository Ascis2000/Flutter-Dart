
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';
import '../services/hive_service.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final HiveService hiveService;
  final VoidCallback? onAdded;
  final VoidCallback? onRemoved;

  const MovieCard({
    super.key,
    required this.movie,
    required this.hiveService,
    this.onAdded,
    this.onRemoved,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  Future<void> _addMovie(BuildContext context) async {
    await widget.hiveService.addMovie(widget.movie);
    if (!mounted) return;
    widget.onAdded?.call();
  }

  Future<void> _removeMovie(BuildContext context) async {
    await widget.hiveService.removeMovie(widget.movie.id);
    if (!mounted) return;
    widget.onRemoved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          /// 1️⃣ Imagen de fondo
          AspectRatio(
            aspectRatio: 2 / 3,
            child: widget.movie.posterUrl.isNotEmpty
                ? Image.network(
                    widget.movie.posterUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Text('Sin imagen')),
                  )
                : const Center(child: Text('Sin imagen')),
          ),

          /// 2️⃣ Capa negra ligera global
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          /// 3️⃣ Gradiente inferior fuerte
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          /// 4️⃣ Contenido inferior (texto + botón)
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.movie.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.movie.year,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder(
                    valueListenable: widget.hiveService.listenable(),
                    builder: (context, Box<Movie> box, _) {
                      final isSaved =
                          widget.hiveService.isMovieSaved(widget.movie.id);

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: isSaved
                            ? OutlinedButton.icon(
                                key: const ValueKey('saved'),
                                onPressed: () => _removeMovie(context),
                                icon: const Icon(Icons.check),
                                label: const Text('En mi lista'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              )
                            : ElevatedButton.icon(
                                key: const ValueKey('add'),
                                onPressed: () => _addMovie(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Añadir a mi lista'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  elevation: 3,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
