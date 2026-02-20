
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import '../models/movie.dart';
import '../services/hive_service.dart';
import '../widgets/movie_card.dart';

/// Pantalla que muestra todas las películas añadidas a la lista personal
/// La lista se obtiene de Hive (persistencia local).
/// Cada tarjeta permite eliminar la película de la lista.
class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  final HiveService _hiveService = HiveService(); // Servicio para acceso a Hive

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ValueListenableBuilder permite actualizar la UI automáticamente
      // cuando cambia la box de Hive (añadir/eliminar películas)
      body: ValueListenableBuilder(
        valueListenable: _hiveService.listenable(),
        builder: (context, Box<Movie> box, _) {

          // Convierte los valores de la box en lista
          final movies = box.values.toList();

          if (movies.isEmpty) {
            // Mensaje cuando la lista está vacía
            return const Center(
              child: Text(
                'No tienes películas en tu lista',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // GridView para mostrar las películas como en HomeScreen
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return MovieCard(
                movie: movie,
                hiveService: _hiveService,
                onRemoved: () {
                  // SnackBar de confirmación al eliminar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${movie.title}" eliminado de tu lista'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onAdded: null, // no es necesario añadir
              );
            },
          );
        },
      ),
    );
  }
}
