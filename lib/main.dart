
// importaciones principales
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/movie.dart';
import 'theme/app_theme.dart';
import 'screens/intro_screen.dart';

/// Box global para almacenar configuraciones persistentes.
/// Se usa para guardar información que debe sobrevivir al cierre de la app,
/// como preferencias de usuario o estado de la app.
late Box settingsBox;

/// Controla el modo de tema de la app de forma reactiva.
/// ValueNotifier permite notificar automáticamente a los widgets que escuchan
/// cuando el valor cambia, sin necesidad de un setState global.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

/// Punto de entrada de la aplicación.
/// Declaramos main() como async porque necesitamos inicializar Hive antes de runApp().
void main() async {

  // Asegura que todos los bindings de Flutter estén inicializados antes de usar plugins
  WidgetsFlutterBinding.ensureInitialized();

  /// Inicializa Hive con soporte para Flutter.
  /// Hive requiere un directorio de almacenamiento accesible para persistencia local.
  await Hive.initFlutter();

  /// NOTA: eliminamos el borrado de la box 'my_movies'
  /// porque estaba causando que los datos guardados se perdieran al reiniciar.

  /// Registra el adaptador generado automáticamente para el modelo Movie.
  /// Esto permite a Hive convertir objetos Movie a binario y viceversa.
  Hive.registerAdapter(MovieAdapter());

  /// Abre la box donde se almacenan las películas guardadas.
  /// Si no existe, Hive la crea automáticamente.
  /// Esta operación es asíncrona porque puede implicar lectura de disco.
  await Hive.openBox<Movie>('my_movies');

  // Box para configuraciones generales de la app
  settingsBox = await Hive.openBox('settings');

  /// Recupera el tema guardado previamente.
  /// Si no existe, se usa 'system' como valor por defecto.
  final savedTheme = settingsBox.get('themeMode', defaultValue: 'system');

  // Configura el ValueNotifier según la preferencia guardada
  if (savedTheme == 'light') {
    themeNotifier.value = ThemeMode.light;
  } else if (savedTheme == 'dark') {
    themeNotifier.value = ThemeMode.dark;
  } else {
    themeNotifier.value = ThemeMode.system;
  }

  /// Ejecuta la app.
  runApp(const MyApp());
}

/// Widget raíz de la aplicación.
/// Stateless porque la gestión de estado se hace mediante ValueNotifier y boxes de Hive.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder reconstruye el MaterialApp
    // automáticamente cuando themeNotifier.value cambia.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {

        // Definimos ThemeData dinámicamente según el valor actual del tema
        ThemeData themeData;

        if (currentTheme == ThemeMode.light) {
          themeData = AppTheme.lightTheme;
        } else if (currentTheme == ThemeMode.dark) {
          themeData = AppTheme.darkTheme;
        } else {
          
          // Si el tema es system, detecta el brillo actual del dispositivo
          final brightness =
              WidgetsBinding.instance.platformDispatcher.platformBrightness;
          themeData = ThemeData(
            useMaterial3: true,
            brightness: brightness,
          );
        }

        /// MaterialApp es el widget principal de la app Flutter.
        /// Contiene rutas, temas, configuración global y el widget home.
        return MaterialApp(
          title: 'APP: MY MOVIES',
          debugShowCheckedModeBanner: false, // Oculta el banner de debug
          theme: themeData, // Tema claro
          darkTheme: AppTheme.darkTheme, // Tema oscuro
          themeMode: currentTheme, // Controla cuál tema aplicar
          home: const IntroScreen(), // Primera pantalla que se muestra
        );
      },
    );
  }
}