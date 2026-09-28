import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/perfil_repository.dart';
import '../../../domain/entities/perfil.dart';

/// Estado de la pantalla de creación de perfil.
///
/// Al crear el perfil, el repositorio siembra el catálogo base de forma automática,
/// sin que esta capa tenga que saberlo.
class CrearPerfilViewModel extends ChangeNotifier {
  CrearPerfilViewModel(this._repository);

  final PerfilRepository _repository;

  bool _guardando = false;
  bool get guardando => _guardando;

  String? _error;
  String? get error => _error;

  /// Crea el perfil y devuelve el resultado, o `null` si la operación falló.
  Future<Perfil?> crearPerfil(String nombre) async {
    if (_guardando) {
      return null;
    }

    _guardando = true;
    _error = null;
    notifyListeners();

    try {
      return await _repository.crearPerfil(nombre);
    } on ArgumentError {
      _error = 'Escribe un nombre para el perfil.';
      return null;
    } catch (e) {
      _error = 'No se pudo crear el perfil. Inténtalo nuevamente.';
      return null;
    } finally {
      _guardando = false;
      notifyListeners();
    }
  }
}
