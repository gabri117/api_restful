import 'package:flutter/material.dart';
import 'widgets/product_list.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Productos',
      theme: ThemeData(
        brightness: Brightness.dark, // Configura el modo oscuro
        primaryColor: Colors.blueAccent, // Color primario para elementos destacados
        scaffoldBackgroundColor: Color(0xFF121212), // Fondo oscuro para toda la app
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        cardColor: Color(0xFF1E1E1E), // Fondo de tarjetas o elementos contenedores
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Texto principal en blanco
          bodyMedium: TextStyle(color: Colors.white70), // Texto secundario en gris claro
          titleLarge: TextStyle(color: Colors.white), // Títulos y subtítulos en blanco
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E), // Fondo de la barra superior
          titleTextStyle: TextStyle(color: Colors.white), // Título en blanco
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent, // Color de los botones
          textTheme: ButtonTextTheme.primary, // Texto de botones en blanco
        ),
      ),
      home: const ProductList(),
    );
  }
}
