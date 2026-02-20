
import 'package:flutter/material.dart';
import '../main.dart';
import 'home_screen.dart';
import 'my_list_screen.dart';
import '../services/hive_service.dart';
import '../widgets/main_drawer.dart'; // Drawer reutilizable con configuración y info

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas a mostrar según la pestaña seleccionada
  final List<Widget> _screens = [
    const HomeScreen(),
    const MyListScreen(),
  ];

  // Títulos del AppBar según la pestaña
  final List<String> _titles = [
    '🎬 Listado Películas TMDB 🎬',
    '📋 Mis Películas',
  ];

  /// Convierte un ThemeMode a String para guardarlo en Hive
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dinámico según pestaña seleccionada
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función de búsqueda pendiente')),
              );
            },
          ),
        ],
      ),

      // Drawer reutilizable con todas las opciones de configuración e info
      drawer: MainDrawer(
        onThemeChanged: (ThemeMode newMode) {
          themeNotifier.value = newMode;
          settingsBox.put(_themeModeToString(newMode), _themeModeToString(newMode));
        },
        onClearList: () async {
          // Llamamos al servicio de Hive para limpiar la box
          await HiveService().clearMovies();

          // Mostramos mensaje de confirmación
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lista de películas borrada'),
                duration: Duration(seconds: 1),
              ),
            );
          }

          // Forzamos actualización de la pantalla MyListScreen si está visible
          if (_selectedIndex == 1) {
            setState(() {}); // Esto refresca el Grid/ListView
          }
        },
      ),

      // Body dinámico: muestra la pantalla según _selectedIndex
      body: _screens[_selectedIndex],

      // BottomNavigationBar para cambiar entre Home y Mis Películas
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Mis Películas',
          ),
        ],
      ),
    );
  }
}
