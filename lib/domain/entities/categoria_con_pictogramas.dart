import 'categoria.dart';
import 'pictograma.dart';

/// Una categoría junto a sus pictogramas activos.
///
/// Es la unidad que consume la cuadrícula del catálogo para mostrar los pictogramas
/// agrupados visualmente por categoría.
class CategoriaConPictogramas {
  const CategoriaConPictogramas({
    required this.categoria,
    required this.pictogramas,
  });

  final Categoria categoria;

  final List<Pictograma> pictogramas;
}
