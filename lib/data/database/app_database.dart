import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tablas.dart';

part 'app_database.g.dart';

/// Base de datos SQLite local de ComunicaPicto.
///
/// Es el único punto de acceso a Drift del proyecto. Las pantallas y los ViewModels
/// nunca la usan directamente: siempre pasan por un repositorio de
/// `lib/data/repositories/`.
@DriftDatabase(tables: [Categorias, Pictogramas, Perfiles, Configuracion])
class AppDatabase extends _$AppDatabase {
  /// Abre la base de datos persistente del dispositivo.
  AppDatabase() : super(_abrirConexion());

  /// Permite inyectar un ejecutor distinto, como `NativeDatabase.memory()` en las
  /// pruebas unitarias.
  AppDatabase.conEjecutor(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Necesario para que SQLite respete la clave foránea Pictogramas → Categorias.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'comunicapicto');
  }
}

/// Claves usadas en la tabla [Configuracion].
abstract final class ClavesConfiguracion {
  /// Marca que el catálogo base ya fue sembrado; impide duplicarlo.
  static const String catalogoBaseInicializado = 'catalogoBaseInicializado';
}
