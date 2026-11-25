import 'package:flutter/material.dart';

import 'data/app_database.dart';
import 'data/tareas_repository.dart';
import 'screens/tareas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const GestorTareasApp());
}

class GestorTareasApp extends StatefulWidget {
  // Permite proporcionar una base de datos para las pruebas.
  final AppDatabase? database;

  const GestorTareasApp({super.key, this.database});

  @override
  State<GestorTareasApp> createState() => _GestorTareasAppState();
}

class _GestorTareasAppState extends State<GestorTareasApp> {
  late final AppDatabase _database;
  late final TareasRepository _repository;

  @override
  void initState() {
    super.initState();

    // Crear una sola instancia de la base de datos.
    _database = widget.database ?? AppDatabase();

    // Crear el repositorio utilizando esa conexión.
    _repository = TareasRepository(_database);
  }

  @override
  void dispose() {
    // Cerrar la conexión si fue creada por la aplicación.
    if (widget.database == null) {
      _database.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TareasPage(repository: _repository),
    );
  }
}
