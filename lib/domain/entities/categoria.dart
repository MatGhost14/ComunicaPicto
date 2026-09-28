/// Categoría que agrupa pictogramas dentro del módulo de Comunicación.
///
/// Modelo de dominio independiente de Drift: es lo que los repositorios entregan a
/// los ViewModels, de modo que la capa de presentación no dependa de la base de datos.
class Categoria {
  const Categoria({
    required this.id,
    required this.nombre,
    required this.esPredeterminada,
    required this.activa,
    required this.orden,
  });

  /// UUID v4.
  final String id;

  final String nombre;

  /// Las categorías del catálogo base no son editables ni eliminables por el adulto.
  final bool esPredeterminada;

  final bool activa;

  /// Orden de presentación en la pantalla de comunicación.
  final int orden;
}
