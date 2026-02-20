
import 'package:flutter/material.dart';
import '../main.dart';

class MainDrawer extends StatelessWidget {
  final void Function(ThemeMode) onThemeChanged;
  final VoidCallback onClearList;

  const MainDrawer({
    super.key,
    required this.onThemeChanged,
    required this.onClearList,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Configuración',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          /// Selector de tema con 3 opciones (Claro / Oscuro / Sistema)
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Selecciona Modo:'),
            subtitle: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentTheme, _) {
                return DropdownButton<ThemeMode>(
                  value: currentTheme,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Claro'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Oscuro'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('Sistema'),
                    ),
                  ],
                  onChanged: (ThemeMode? newMode) {
                    if (newMode == null) return;
                    onThemeChanged(newMode);
                  },
                );
              },
            ),
          ),

          /// Opción para limpiar la lista de películas guardadas en Hive
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Limpiar lista'),
            onTap: () {
              Navigator.pop(context);
              onClearList();
            },
          ),

          /// Información de la App (diálogo About)
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Información'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'My Movies App',
                applicationVersion: '0.1.0',
                children: const [
                  Text(
                      'App de películas con lista personal adaptable')
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
