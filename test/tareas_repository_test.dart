import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/app_database.dart';
import 'package:gestor_tareas_local/data/tareas_repository.dart';

void main() {
  late AppDatabase database;
  late TareasRepository repository;

  // Crear una base de datos independiente para cada prueba.
  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = TareasRepository(database);
  });

  // Cerrar la base de datos al terminar cada prueba.
  tearDown(() async {
    await database.close();
  });

  // Prueba 2: validar títulos vacíos o con espacios.
  test('No permite registrar tareas con títulos vacíos', () async {
    await expectLater(repository.agregarTarea(''), throwsArgumentError);

    await expectLater(repository.agregarTarea('   '), throwsArgumentError);

    final tareas = await repository.observarTareas().first;

    expect(tareas, isEmpty);
  });

  // Prueba 3: comprobar las operaciones CRUD.
  test('Permite realizar las operaciones CRUD de una tarea', () async {
    // CREATE: agregar una tarea.
    final id = await repository.agregarTarea('Estudiar SQLite');

    // READ: consultar la tarea registrada.
    var tareas = await repository.observarTareas().first;

    expect(tareas.length, 1);
    expect(tareas.first.id, id);
    expect(tareas.first.titulo, 'Estudiar SQLite');
    expect(tareas.first.completada, isFalse);

    // UPDATE: editar el título.
    await repository.editarTarea(id, 'Estudiar Drift');

    tareas = await repository.observarTareas().first;

    expect(tareas.first.titulo, 'Estudiar Drift');

    // UPDATE: marcar como completada.
    await repository.actualizarEstado(id, true);

    tareas = await repository.observarTareas().first;

    expect(tareas.first.completada, isTrue);

    // UPDATE: regresar al estado pendiente.
    await repository.actualizarEstado(id, false);

    tareas = await repository.observarTareas().first;

    expect(tareas.first.completada, isFalse);

    // DELETE: eliminar la tarea.
    await repository.eliminarTarea(id);

    tareas = await repository.observarTareas().first;

    expect(tareas, isEmpty);
  });
}
