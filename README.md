
# Gestor de tareas con SQLite

## Información general

- Universidad Autónoma de Aguascalientes.
- Ingeniería en Sistemas Computacionales.
- Séptimo semestre.
- Materia: Programación de Dispositivos Móviles.
- Modalidad: Individual.

## Objetivo

Desarrollar una aplicación Flutter para gestionar tareas mediante
una base de datos SQLite local, permitiendo conservar la información
después de cerrar y volver a abrir la aplicación.

## Plataformas objetivo

De acuerdo con la aclaración de la práctica, la aplicación deberá
funcionar en tres entornos:

- Móvil: Android.
- Escritorio: Windows.
- Web: Google Chrome.

Se utilizará una sola base de código Flutter, sin sincronización
de información entre dispositivos.

## Funcionalidades

- [x] Agregar tareas.
- [x] Consultar tareas almacenadas.
- [x] Editar el título de una tarea.
- [x] Marcar tareas como completadas o pendientes.
- [x] Eliminar tareas.
- [x] Validar títulos vacíos durante el alta y la edición.
- [x] Conservar datos después de reiniciar la aplicación.
- [x] Manejar errores de almacenamiento en las operaciones CRUD.
- [ ] Verificar funcionamiento multiplataforma.

## Tecnología de persistencia

Se utiliza SQLite como base de datos relacional local.

Se seleccionó Drift porque permite definir tablas, ejecutar
operaciones CRUD y realizar consultas reactivas desde Dart.

Se utiliza drift_flutter para facilitar la apertura de la
base de datos en las distintas plataformas.

Para generar el código necesario se utilizan drift_dev
y build_runner.

La versión web requerirá recursos WebAssembly compatibles
con las dependencias instaladas. Su configuración se
realizará durante la etapa 4.

## Diseño de la base de datos

Se implementó una tabla llamada `tareas`.

| Campo | Tipo SQLite | Restricciones |
|---|---|---|
| id | INTEGER | Clave primaria autoincremental |
| titulo | TEXT | Obligatorio, no vacío |
| completada | INTEGER | 0 o 1, valor inicial 0 |

El campo id identifica cada tarea de manera única.

El campo completada representa su estado:

- 0: Pendiente.
- 1: Completada.

## Actualización de la interfaz

Se utilizan consultas reactivas mediante Stream y
StreamBuilder para mostrar automáticamente los cambios
realizados en la base de datos.

La consulta se inicializa en initState(), evitando
realizar consultas directamente dentro de build().

## Estructura del proyecto

    lib/
        main.dart
        data/
            app_database.dart
            app_database.g.dart
            tareas_repository.dart
        models/
            tarea.dart
        screens/
            tareas_page.dart
    test/
        widget_test.dart
    evidencias/
        etapa_2/
        etapa_3/

- app_database.dart: definición de la tabla y conexión SQLite.
- app_database.g.dart: código generado automáticamente por Drift.
- tareas_repository.dart: validaciones y operaciones CRUD.
- tarea.dart: modelo de datos utilizado por la interfaz.
- tareas_page.dart: interfaz, operaciones CRUD y consultas reactivas.
- main.dart: inicialización y administración de la conexión.
- widget_test.dart: prueba automatizada de la interfaz inicial.

## Entorno de desarrollo

- Flutter 3.47.3.
- Dart 3.13.3.
- Windows 11.
- Android SDK 36.0.0.
- Visual Studio Community 2022.

## Ejecución inicial

Obtener las dependencias:

    flutter pub get

Consultar dispositivos disponibles:

    flutter devices

Analizar el código:

    flutter analyze

Ejecutar las pruebas:

    flutter test

Ejecutar en Chrome (pendiente de configurar SQLite para web):

    flutter run -d chrome --web-port=8080

Ejecutar en Windows:

    flutter run -d windows

Actualmente, la persistencia SQLite está implementada y
verificada en Windows. La configuración y comprobación
de SQLite en web se realizará durante la etapa 4.

## Estado del desarrollo

- [x] Etapa 1: Preparación y diseño.
- [x] Etapa 2: Persistencia real.
- [x] Etapa 3: Operaciones CRUD restantes.
- [ ] Etapa 4: Compatibilidad y pruebas.
- [ ] Reporte final.

## Etapa 1: Preparación y diseño

Fecha: 24/11/2026.

### Actividades realizadas

- Verificación del entorno de desarrollo Flutter.
- Creación del proyecto gestor_tareas_local.
- Incorporación del código base proporcionado por el profesor.
- Ejecución de la interfaz inicial en Chrome.
- Configuración del repositorio GitHub.
- Selección de SQLite y Drift como tecnología de persistencia.
- Diseño de la tabla de tareas.
- Documentación inicial del proyecto.

### Verificaciones técnicas

- Flutter doctor: sin problemas detectados.
- Flutter pub get: dependencias obtenidas correctamente.
- Flutter analyze: una sugerencia prefer_final_fields.
- Flutter test: una prueba aprobada.
- Chrome: interfaz inicial ejecutada correctamente.

Durante esta primera etapa todavía no se había
implementado la persistencia SQLite.

La sugerencia prefer_final_fields se resolvió durante
la implementación de la etapa 2.

### Uso de inteligencia artificial en la etapa 1

Se utilizó ChatGPT como apoyo para interpretar los requisitos
de la práctica, organizar las etapas de desarrollo, investigar
alternativas de persistencia y preparar la documentación inicial.

Las pruebas y verificaciones de funcionamiento se realizan
localmente durante el desarrollo.

## Etapa 2: Implementación de persistencia SQLite

Fecha: 24/11/2026.

### Dependencias instaladas

| Dependencia | Versión |
|---|---|
| drift | 2.35.4 |
| drift_flutter | 0.3.1 |
| drift_dev | 2.35.3 |
| build_runner | 2.17.1 |
| sqlite3 | 3.5.2 |

### Generación de código

Para generar el código de Drift se utiliza:

    dart run build_runner build

El parámetro --delete-conflicting-outputs indicado en la
consigna original fue eliminado en la versión instalada
de build_runner, por lo que ya no es necesario.

### Implementación

Se implementó una base de datos SQLite mediante Drift,
con una tabla de tareas que contiene identificador
autoincremental, título y estado de completado.

Se implementaron las operaciones INSERT y SELECT mediante
un repositorio independiente de la interfaz.

La consulta de tareas utiliza watch(), Stream y StreamBuilder
para actualizar automáticamente la interfaz cuando se
registran nuevos datos.

Se utiliza trim() para eliminar espacios exteriores y
rechazar títulos vacíos o compuestos únicamente por espacios.

La conexión se inicializa una sola vez y se libera cuando
corresponde durante el ciclo de vida de la aplicación.

### Dificultad técnica encontrada

Durante la ejecución de flutter test se presentó el error:

    A Timer is still pending even after the widget tree was disposed.

El problema estaba relacionado con el cierre diferido de
las consultas reactivas de Drift durante las pruebas.

Se corrigió utilizando una DatabaseConnection con la opción
closeStreamsSynchronously: true en la base de datos de pruebas.

Después de realizar la corrección se ejecutaron nuevamente
flutter analyze y flutter test, obteniendo resultados exitosos.


## Resultados de las pruebas

| ID | Prueba | Plataforma | Resultado |
|---|---|---|---|
| P1 | Registrar tres tareas y cerrar y abrir la aplicación | Windows | Aprobada |
| P2 | Cambiar estado y reiniciar | Windows | Aprobada |
| P3 | Editar título y reiniciar | Windows | Aprobada |
| P4 | Eliminar tarea y reiniciar | Windows | Aprobada |
| P5 | Rechazar títulos vacíos o con espacios | Windows | Aprobada |
| P6 | Persistencia en navegador | Web | Pendiente |


### Verificaciones técnicas

- flutter analyze: No issues found.
- flutter test: 1 prueba aprobada.
- Ejecución nativa en Windows: exitosa.
- Persistencia después de cerrar y abrir: comprobada.
- Validación de títulos vacíos: comprobada.

### Uso de inteligencia artificial en la etapa 2

Se utilizó ChatGPT como apoyo para la implementación de
la base de datos, el repositorio, las consultas reactivas,
la integración con la interfaz y la corrección de la
prueba automatizada.

Se verificaron localmente la generación del código,
el análisis estático, la prueba automatizada, la ejecución
en Windows y la persistencia real de los datos.


## Etapa 3: Operaciones CRUD restantes

Fecha: 24/11/2026.

### Actividades realizadas

- Implementación de la edición del título de una tarea.
- Implementación del cambio de estado de una tarea.
- Implementación de la eliminación de tareas mediante su ID.
- Integración de las operaciones con la interfaz.
- Validación de títulos durante la edición.
- Manejo de errores en las operaciones de actualización y eliminación.

### Archivos modificados

- lib/data/tareas_repository.dart
- lib/screens/tareas_page.dart

No fue necesario modificar la estructura de la base de datos,
instalar nuevas dependencias ni generar nuevamente el código
de Drift.

### Implementación

Se completaron las operaciones CRUD mediante los métodos
del repositorio de tareas.

| Operación | Método | Instrucción SQL |
|---|---|---|
| Create | agregarTarea() | INSERT |
| Read | observarTareas() | SELECT |
| Update | editarTarea() | UPDATE |
| Update | actualizarEstado() | UPDATE |
| Delete | eliminarTarea() | DELETE |

Las operaciones de actualización y eliminación utilizan
el identificador único de cada tarea mediante una condición
WHERE, evitando modificar otros registros de la tabla.

Se utiliza Value() de Drift para especificar los campos
que deben actualizarse sin modificar los demás atributos.

También se verifica el número de filas afectadas para
detectar operaciones sobre registros inexistentes.

### Integración con la interfaz

Se implementó una ventana de diálogo sencilla mediante
AlertDialog y TextFormField para editar el título de una tarea.

El estado de completado se modifica mediante el Checkbox
de cada registro.

La eliminación se realiza directamente mediante el botón
correspondiente y el identificador de la tarea.

Se conservaron las consultas reactivas mediante watch()
y StreamBuilder, permitiendo actualizar automáticamente
la interfaz después de cada operación.

Se mantuvo una interfaz sencilla y funcional, de acuerdo
con los requisitos de la práctica.

### Validaciones y manejo de errores

- Se rechazan títulos vacíos o compuestos únicamente por espacios.
- Se utiliza trim() para eliminar espacios exteriores.
- Se utilizan bloques try/catch para manejar errores de almacenamiento.
- Se verifica mounted antes de mostrar mensajes después de una operación asíncrona.
- Se comprueba que las tareas existan antes de considerar exitosa una actualización o eliminación.

### Verificaciones técnicas

- Análisis estático del código.
- Ejecución de las pruebas automatizadas existentes.
- Ejecución de la aplicación en Windows.
- Verificación de las operaciones de edición, cambio de estado y eliminación.

### Uso de inteligencia artificial en la etapa 3

Se utilizó ChatGPT como apoyo para implementar las operaciones
UPDATE y DELETE mediante Drift, integrar las operaciones
con la interfaz y revisar las validaciones y el manejo
de errores.

Se solicitó simplificar el código para conservar únicamente
los elementos necesarios para cumplir los requisitos de
la práctica, evitando funcionalidades adicionales.

La implementación y las verificaciones de funcionamiento
se realizaron localmente.

## Fuentes consultadas

- https://drift.simonbinder.eu/
  Documentación general de Drift, definición de tablas,
  operaciones CRUD y consultas reactivas.

- https://pub.dev/packages/drift_flutter
  Apertura de bases de datos en distintas plataformas Flutter.

- https://drift.simonbinder.eu/platforms/web/
  Requisitos de SQLite en navegadores, WebAssembly
  y almacenamiento local.

- https://drift.simonbinder.eu/testing/
  Configuración de pruebas automatizadas con Drift y
  solución del problema de temporizadores pendientes
  mediante closeStreamsSynchronously.
