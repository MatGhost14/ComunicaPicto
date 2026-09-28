import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/pictograma_repository.dart';
import '../../../domain/entities/categoria_con_pictogramas.dart';

/// Estado de la pantalla del catálogo de pictogramas.
///
/// Sólo conversa con [PictogramaRepository]; no conoce Drift ni la base de datos.
class CatalogoViewModel extends ChangeNotifier {
  CatalogoViewModel(this._repository);

  final PictogramaRepository _repository;

  bool _cargando = true;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  List<CategoriaConPictogramas> _categorias = const <CategoriaConPictogramas>[];
  List<CategoriaConPictogramas> get categorias => _categorias;

  /// `true` cuando la carga terminó sin error pero no hay pictogramas que mostrar.
  bool get vacio => !_cargando && _error == null && _categorias.isEmpty;

  /// Carga el catálogo agrupado por categoría.
  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _categorias = await _repository.obtenerActivosPorCategoria();
    } catch (e) {
      _error = 'No se pudo cargar el catálogo de pictogramas.';
      _categorias = const <CategoriaConPictogramas>[];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
