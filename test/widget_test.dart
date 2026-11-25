import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gestor_tareas_local/main.dart';
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  testWidgets('La pantalla inicial se muestra sin errores', (tester) async {
    // Base de datos temporal para las pruebas.
    final database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    addTearDown(database.close);

    await tester.pumpWidget(GestorTareasApp(database: database));

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Permitir que finalice la consulta inicial.
    await tester.runAsync(() async {
      await database.select(database.tareas).get();
    });

    await tester.pump();

    // Retirar la interfaz antes de cerrar la conexión.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
