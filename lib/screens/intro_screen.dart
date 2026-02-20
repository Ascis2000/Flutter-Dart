
import 'package:flutter/material.dart';
import 'main_screen.dart';

/// Pantalla de introducción.
/// Se muestra al iniciar la app y redirige automáticamente
/// a la pantalla principal tras unos segundos.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

/// Estado asociado a IntroScreen.
/// Aquí gestionamos el temporizador y la navegación automática.
class _IntroScreenState extends State<IntroScreen> {

  /// initState se ejecuta una única vez cuando el widget
  /// se inserta en el árbol de widgets.
  @override
  void initState() {
    super.initState();
    _goToMain();
  }

  /// Método privado que espera 5 segundos y luego
  /// navega hacia la pantalla principal.
  /// Se usa Future.delayed para simular carga inicial
  void _goToMain() async {

    // Espera 5 segundos antes de continuar
    await Future.delayed(const Duration(seconds: 5));

    /// Verifica que el widget siga montado en el árbol.
    /// Esto evita errores si el usuario abandona la pantalla
    /// antes de que termine el temporizador.
    if (!mounted) return;

    /// pushReplacement reemplaza la pantalla actual
    /// para que el usuario no pueda volver atrás con el botón back.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    /// Scaffold
    return Scaffold(
      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F0FF),
              Color(0xFF5DADE2),
            ],
          ),
        ),

        /// Centra el contenido principal en pantalla
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),

            /// Caja semitransparente con bordes redondeados
            decoration: BoxDecoration(

              /// Cpropiedades del Box
              color: Color.fromARGB((0.4 * 255).round(), 34, 41, 54),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),

            /// Column
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [

                /// Título
                Text(
                  '🎬 My Movies App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),

                // Subtitulo
                SizedBox(height: 12),
                Text(
                  'Tu App personalizada de películas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 32),

                /// Indicador de carga
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),

                SizedBox(height: 12),

                /// Texto auxiliar
                Text(
                  'Cargando datos...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
