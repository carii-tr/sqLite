import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../data/tareas_repository.dart';

class TareasPage extends StatefulWidget {
  final TareasRepository repository;

  const TareasPage({super.key, required this.repository});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();

  // Stream que contiene las tareas almacenadas en SQLite.
  late final Stream<List<Tarea>> _tareasStream;

  // Evita registros repetidos mientras se guarda una tarea.
  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    // La consulta se inicializa fuera de build().
    _tareasStream = widget.repository.observarTareas();
  }

  // CREATE: guardar una tarea en SQLite.
  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      _mostrarMensaje('El título no puede estar vacío');
      return;
    }

    if (_guardando) return;

    setState(() {
      _guardando = true;
    });

    try {
      await widget.repository.agregarTarea(titulo);

      if (!mounted) return;

      _tituloController.clear();
      _mostrarMensaje('Tarea guardada correctamente');
    } catch (error) {
      if (!mounted) return;

      _mostrarMensaje('No se pudo guardar la tarea');
      debugPrint('Error al guardar: $error');
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  // UPDATE: cambiar el estado de una tarea.
  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    try {
      await widget.repository.actualizarEstado(tarea.id, completada);
    } catch (error) {
      if (!mounted) return;

      _mostrarMensaje('No se pudo actualizar el estado');
      debugPrint('Error: $error');
    }
  }

  // UPDATE: editar el título de una tarea.
  Future<void> _editarTarea(Tarea tarea) async {
    String nuevoTitulo = tarea.titulo;

    // Mostrar una ventana para editar el título.
    final tituloEditado = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: TextFormField(
            initialValue: tarea.titulo,
            onChanged: (valor) {
              nuevoTitulo = valor;
            },
            decoration: const InputDecoration(labelText: 'Nuevo título'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, nuevoTitulo.trim());
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    // Verificar que no se haya cancelado la edición.
    if (!mounted || tituloEditado == null) return;

    // Rechazar títulos vacíos.
    if (tituloEditado.isEmpty) {
      _mostrarMensaje('El título no puede estar vacío');
      return;
    }

    try {
      await widget.repository.editarTarea(tarea.id, tituloEditado);
    } catch (error) {
      if (!mounted) return;

      _mostrarMensaje('No se pudo editar la tarea');
      debugPrint('Error: $error');
    }
  }

  // DELETE: eliminar una tarea mediante su ID.
  Future<void> _eliminarTarea(Tarea tarea) async {
    try {
      await widget.repository.eliminarTarea(tarea.id);
    } catch (error) {
      if (!mounted) return;

      _mostrarMensaje('No se pudo eliminar la tarea');
      debugPrint('Error: $error');
    }
  }

  // Mostrar mensajes al usuario.
  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              enabled: !_guardando,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            FilledButton.icon(
              onPressed: _guardando ? null : _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),

            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            // READ: mostrar las tareas almacenadas en SQLite.
            Expanded(
              child: StreamBuilder<List<Tarea>>(
                stream: _tareasStream,
                builder: (context, snapshot) {
                  // Manejo de errores de consulta.
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudieron consultar las tareas'),
                    );
                  }

                  // Indicador mientras se realiza la consulta.
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tareas = snapshot.data!;

                  if (tareas.isEmpty) {
                    return const Center(
                      child: Text('Todavía no hay tareas guardadas'),
                    );
                  }

                  return ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.completada,
                            onChanged: (valor) {
                              if (valor != null) {
                                _alternarCompletada(tarea, valor);
                              }
                            },
                          ),
                          title: Text(tarea.titulo),
                          subtitle: Text('ID: ${tarea.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editarTarea(tarea),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _eliminarTarea(tarea),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
