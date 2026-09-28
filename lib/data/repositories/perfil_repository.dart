import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/perfil.dart';
import '../database/app_database.dart';
import '../database/seed_catalogo_base.dart';

/// Acceso a los perfiles de la aplicación.
///
/// Es el responsable de garantizar el criterio de aceptación 1 de la HU1: al crear un
/// perfil, el catálogo base queda asociado y disponible automáticamente.
class PerfilRepository {
  PerfilRepository(this._db, {Uuid uuid = const Uuid()})
      : _uuid = uuid,
        _seed = SeedCatalogoBase(_db, uuid: uuid);

  final AppDatabase _db;
  final Uuid _uuid;
  final SeedCatalogoBase _seed;

  /// Crea un perfil y se asegura de que el catálogo base esté sembrado.
  ///
  /// La siembra es idempotente: si el catálogo ya existe porque se creó un perfil
  /// anterior, no se vuelve a insertar.
  Future<Perfil> crearPerfil(String nombre) async {
    final nombreLimpio = nombre.trim();
    if (nombreLimpio.isEmpty) {
      throw ArgumentError.value(nombre, 'nombre', 'El nombre del perfil no puede estar vacío');
    }

    final perfil = Perfil(
      id: _uuid.v4(),
      nombre: nombreLimpio,
      activo: true,
      creadoEn: DateTime.now(),
    );

    await _db.into(_db.perfiles).insert(
          PerfilesCompanion.insert(
            id: perfil.id,
            nombre: perfil.nombre,
            activo: Value(perfil.activo),
            creadoEn: perfil.creadoEn,
          ),
        );

    await _seed.ejecutar();

    return perfil;
  }

  /// Perfiles activos, del más reciente al más antiguo.
  Future<List<Perfil>> obtenerActivos() async {
    final consulta = _db.select(_db.perfiles)
      ..where((fila) => fila.activo.equals(true))
      ..orderBy([(fila) => OrderingTerm.desc(fila.creadoEn)]);

    final filas = await consulta.get();
    return filas.map(_aDominio).toList();
  }

  Perfil _aDominio(PerfilRow fila) => Perfil(
        id: fila.id,
        nombre: fila.nombre,
        activo: fila.activo,
        creadoEn: fila.creadoEn,
      );
}
