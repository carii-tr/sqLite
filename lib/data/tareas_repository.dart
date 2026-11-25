import 'app_database.dart';
import '../models/tarea.dart';

// Repositorio encargado de las operaciones
// de almacenamiento y consulta de tareas.
class TareasRepository {
  final AppDatabase _database;

  TareasRepository(this._database);

  // CREATE: agregar una tarea a SQLite.
  Future<int> agregarTarea(String titulo) async {
    // Eliminar espacios al inicio y al final.
    final tituloLimpio = titulo.trim();

    // Evitar registrar tareas vacías.
    if (tituloLimpio.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }

    // Insertar la tarea y devolver su identificador.
    return await _database
        .into(_database.tareas)
        .insert(TareasCompanion.insert(titulo: tituloLimpio));
  }

  // READ: consultar las tareas de forma reactiva.
  Stream<List<Tarea>> observarTareas() {
    return _database.select(_database.tareas).watch().map((registros) {
      return registros.map((registro) {
        return Tarea(
          id: registro.id,
          titulo: registro.titulo,
          completada: registro.completada,
        );
      }).toList();
    });
  }
}
