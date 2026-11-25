import 'package:drift/drift.dart';

import 'app_database.dart';
import '../models/tarea.dart';

// Repositorio encargado de las operaciones CRUD
// y la persistencia de las tareas.
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

  // UPDATE: modificar el título de una tarea existente.
  Future<void> editarTarea(int id, String titulo) async {
    final tituloLimpio = titulo.trim();

    // Validar también durante la edición.
    if (tituloLimpio.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }

    // Actualizar únicamente la tarea con el ID indicado.
    final filasAfectadas =
        await (_database.update(_database.tareas)
              ..where((tabla) => tabla.id.equals(id)))
            .write(TareasCompanion(titulo: Value(tituloLimpio)));

    if (filasAfectadas == 0) {
      throw StateError('La tarea no existe');
    }
  }

  // UPDATE: cambiar el estado de una tarea.
  Future<void> actualizarEstado(int id, bool completada) async {
    final filasAfectadas =
        await (_database.update(_database.tareas)
              ..where((tabla) => tabla.id.equals(id)))
            .write(TareasCompanion(completada: Value(completada)));

    if (filasAfectadas == 0) {
      throw StateError('La tarea no existe');
    }
  }

  // DELETE: eliminar una tarea utilizando su ID.
  Future<void> eliminarTarea(int id) async {
    final filasAfectadas = await (_database.delete(
      _database.tareas,
    )..where((tabla) => tabla.id.equals(id))).go();

    if (filasAfectadas == 0) {
      throw StateError('La tarea no existe');
    }
  }
}
