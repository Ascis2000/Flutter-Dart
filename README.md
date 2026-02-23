
# Flutter Movies App 🎬

Aplicación Flutter para gestionar, valorar y comentar películas.

## Estructura
Leer fichero /lib/informacion/info.txt
    
---

## 🏃‍♂️ Flujo Principal

- `main.dart` → Inicializa Hive y lanza `MainScreen`
- `IntroScreen` → Pantalla de carga y bienvenida
- `MainScreen` → Contenedor con `BottomNavigationBar`:
  - **Índice 0:** `HomeScreen` → GridView con películas populares TMDB
  - **Índice 1:** `MyListScreen` → Lista personal guardada en Hive
- `MovieCard` → Widget reutilizable para mostrar información de películas
- `MainDrawer` → Drawer global con:
  - Selector de tema (Claro / Oscuro / Sistema)
  - Limpiar lista personal
  - Información de la app

---

## 🔧 Servicios

- **ApiService** → Conecta con TMDB y devuelve lista de películas como objetos `Movie`.
- **HiveService** → CRUD sobre Hive:
  - `addMovie(movie)` → Añadir película
  - `deleteMovie(movie)` → Eliminar película
  - `getMovies()` → Obtener lista completa

---

## 🎨 Modelos y Persistencia

- `Movie` → Modelo de datos con propiedades: `id`, `title`, `year`, `posterPath`, `overview`, `rating`
- Anotaciones Hive: `@HiveType(typeId: X)` y `@HiveField(n)`  
- Archivo `movie.g.dart` → Generado automáticamente para serialización

---

## 🎨 Temas

- `app_theme.dart` define:
  - `lightTheme`
  - `darkTheme`
  - `systemTheme`
- Configuración global de colores, tipografías y estilos
- Se aplica según `themeNotifier` y `ThemeMode`

---

## ⭐ Funcionalidades

1. Explorar películas populares desde TMDB
2. Crear lista personal (añadir/eliminar)
3. Persistencia local con Hive
4. Actualización automática de la UI
5. Feedback al usuario mediante SnackBars
6. Selector de tema (Claro / Oscuro / Sistema)
7. Escalabilidad futura: filtros, ordenación, búsqueda

---

## 🗓️ Desarrollo Paso a Paso

**Día 1**
- Crear proyecto Flutter
- Instalar dependencias (Hive, HTTP)
- Crear modelo `Movie` y generar `movie.g.dart`
- Crear `HomeScreen` básico
- Inicializar Hive en `main.dart`
- Mostrar películas de TMDB cargando dinámicamente de 20 en 20

**Día 2**
- Revisar funcionalidad
- Dropdown de selección de tema en Drawer
- Crear documentación de la app

**Día 3**
- Definir estilos light/dark
- Rediseñar estilos de `movie_screen`
- Continuar documentación

**Día 4**
- Implementar Drawer global como widget reutilizable
- Añadir búsqueda por género
- Implementar filtros/ordenación en `HomeScreen`

**Día 5**
- Mejorar filtros por género y año
- Finalizar documentación
- Subir proyecto a GitHub

---

## 🎯 Pulido y Detalles Finales

- Botón de búsqueda
- Mejora de UI/UX (cards, imágenes, animaciones)
- Mensajes y SnackBars
- Validaciones y manejo de errores
- Testing básico de funcionalidades

---

## 📌 Resumen

**My Movies App** combina Flutter, Dart y Hive para ofrecer exploración de películas, gestión de lista personal, persistencia local y temas personalizables, con arquitectura modular y escalabilidad para futuras mejoras.
