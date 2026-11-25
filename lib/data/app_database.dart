import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Archivo que será generado automáticamente por Drift.
part 'app_database.g.dart';

// Definición de la tabla tareas.
// Utilizamos TareaRegistro para evitar conflictos
// con el modelo Tarea proporcionado por el profesor.
@DataClassName('TareaRegistro')
class Tareas extends Table {
  // Identificador único autoincremental.
  IntColumn get id => integer().autoIncrement()();

  // Título obligatorio de la tarea.
  TextColumn get titulo => text().withLength(min: 1)();

  // Estado de la tarea: pendiente por defecto.
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

// Clase principal de la base de datos.
@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  // Permite utilizar una conexión real o una de pruebas.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrirConexion());

  // Versión inicial del esquema.
  @override
  int get schemaVersion => 1;

  // Configuración multiplataforma.
  static QueryExecutor _abrirConexion() {
    return driftDatabase(
      name: 'gestor_tareas',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}
