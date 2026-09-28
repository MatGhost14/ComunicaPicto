import 'package:drift/drift.dart';

import '../../domain/entities/categoria.dart';
import '../../domain/entities/categoria_con_pictogramas.dart';
import '../../domain/entities/pictograma.dart';
import '../database/app_database.dart';

/// Acceso de lectura al catálogo de pictogramas.
///
/// Devuelve entidades de dominio, nunca filas de Drift, para que los ViewModels y las
/// pantallas no dependan de la base de datos.
class PictogramaRepository {
  PictogramaRepository(this._db);

  final AppDatabase _db;

  /// Pictogramas activos agrupados por categoría activa.
  ///
  /// Las categorías se devuelven según su campo `orden` y, a igualdad de orden, por
  /// nombre. Las categorías sin pictogramas activos se omiten.
  Future<List<CategoriaConPictogramas>> obtenerActivosPorCategoria() async {
    final consultaCategorias = _db.select(_db.categorias)
      ..where((fila) => fila.activa.equals(true))
      ..orderBy([
        (fila) => OrderingTerm.asc(fila.orden),
        (fila) => OrderingTerm.asc(fila.nombre),
      ]);

    final consultaPictogramas = _db.select(_db.pictogramas)
      ..where((fila) => fila.activo.equals(true))
      ..orderBy([(fila) => OrderingTerm.asc(fila.texto)]);

    final filasCategorias = await consultaCategorias.get();
    final filasPictogramas = await consultaPictogramas.get();

    final porCategoria = <String, List<Pictograma>>{};
    for (final fila in filasPictogramas) {
      porCategoria.putIfAbsent(fila.categoriaId, () => <Pictograma>[]).add(_aPictograma(fila));
    }

    final resultado = <CategoriaConPictogramas>[];
    for (final filaCategoria in filasCategorias) {
      final pictogramas = porCategoria[filaCategoria.id];
      if (pictogramas == null || pictogramas.isEmpty) {
        continue;
      }
      resultado.add(
        CategoriaConPictogramas(
          categoria: _aCategoria(filaCategoria),
          pictogramas: pictogramas,
        ),
      );
    }

    return resultado;
  }

  Categoria _aCategoria(CategoriaRow fila) => Categoria(
        id: fila.id,
        nombre: fila.nombre,
        esPredeterminada: fila.esPredeterminada,
        activa: fila.activa,
        orden: fila.orden,
      );

  Pictograma _aPictograma(PictogramaRow fila) => Pictograma(
        id: fila.id,
        texto: fila.texto,
        rutaImagen: fila.rutaImagen,
        categoriaId: fila.categoriaId,
        esPersonalizado: fila.esPersonalizado,
        activo: fila.activo,
      );
}
