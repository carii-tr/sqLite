
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

- [ ] Agregar tareas.
- [ ] Consultar tareas almacenadas.
- [ ] Editar el título de una tarea.
- [ ] Marcar tareas como completadas o pendientes.
- [ ] Eliminar tareas.
- [ ] Validar títulos vacíos.
- [ ] Conservar datos después de reiniciar la aplicación.
- [ ] Manejar errores de almacenamiento.
- [ ] Verificar funcionamiento multiplataforma.

## Tecnología de persistencia

Se utilizará SQLite como base de datos relacional local.

Se seleccionó Drift porque permite definir tablas, ejecutar
operaciones CRUD y realizar consultas reactivas desde Dart.

Se utilizará drift_flutter para facilitar la apertura de la
base de datos en las distintas plataformas.

Para generar el código necesario se utilizarán drift_dev
y build_runner.

La versión web requerirá recursos WebAssembly compatibles
con las dependencias instaladas.

## Diseño de la base de datos

Se propone una tabla llamada `tareas`.

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

Se propone utilizar consultas reactivas mediante Stream
y StreamBuilder para mostrar automáticamente los cambios
realizados en la base de datos.

## Estructura inicial

    lib/
        main.dart
        data/
        models/
            tarea.dart
        screens/
            tareas_page.dart
    test/
        widget_test.dart

La carpeta data contendrá la capa de persistencia.

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

Ejecutar en Chrome:

    flutter run -d chrome --web-port=8080

Ejecutar en Windows:

    flutter run -d windows

La configuración de SQLite y sus recursos web se documentará
conforme avance la implementación.

## Estado del desarrollo

- [x] Etapa 1: Preparación y diseño.
- [ ] Etapa 2: Persistencia real.
- [ ] Etapa 3: Operaciones CRUD restantes.
- [ ] Etapa 4: Compatibilidad y pruebas.
- [ ] Reporte final.

## Verificaciones iniciales

- Flutter doctor: sin problemas detectados.
- Flutter pub get: dependencias obtenidas correctamente.
- Flutter analyze: una sugerencia prefer_final_fields.
- Flutter test: una prueba aprobada.
- Chrome: interfaz inicial ejecutada correctamente.

Todavía no se ha implementado la persistencia SQLite.

## Fuentes consultadas

- https://drift.simonbinder.eu/
  Documentación general de Drift, tablas y consultas reactivas.

- https://pub.dev/packages/drift_flutter
  Apertura de bases de datos en distintas plataformas Flutter.

- https://drift.simonbinder.eu/platforms/web/
  Requisitos de SQLite en navegadores y almacenamiento local.

## Uso de inteligencia artificial

Se utilizó ChatGPT como apoyo para interpretar los requisitos
de la práctica, organizar las etapas de desarrollo, investigar
alternativas de persistencia y preparar la documentación inicial.

Las pruebas y verificaciones de funcionamiento se realizan
localmente durante el desarrollo.
