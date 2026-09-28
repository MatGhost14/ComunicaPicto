import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

/// Siembra del catálogo base de pictogramas y categorías predeterminadas (HU1).
///
/// El catálogo se incorpora localmente en la aplicación: los pictogramas son assets
/// del propio paquete y la siembra no realiza ninguna llamada de red.
///
/// La operación es idempotente. Se controla mediante el indicador
/// [ClavesConfiguracion.catalogoBaseInicializado] de la tabla `Configuracion`, de modo
/// que crear un segundo perfil no vuelve a insertar el catálogo.
class SeedCatalogoBase {
  SeedCatalogoBase(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Directorio de assets donde vive el catálogo base.
  static const String _directorioBase = 'assets/pictogramas/base';

  /// Definición del catálogo base: 4 categorías predeterminadas y 24 pictogramas.
  ///
  /// Los pictogramas provienen de ARASAAC (Gobierno de Aragón, autor Sergio Palao),
  /// bajo licencia Creative Commons BY-NC-SA. El identificador original de ARASAAC de
  /// cada uno queda documentado en `PICTOGRAMAS_CATALOGO_BASE.md`.
  static const List<DefinicionCategoria> catalogoBase = <DefinicionCategoria>[
    DefinicionCategoria(
      nombre: 'Necesidades básicas',
      orden: 0,
      pictogramas: <DefinicionPictograma>[
        DefinicionPictograma(texto: 'Agua', archivo: 'agua.png'),
        DefinicionPictograma(texto: 'Baño', archivo: 'bano.png'),
        DefinicionPictograma(texto: 'Dormir', archivo: 'dormir.png'),
        DefinicionPictograma(texto: 'Ayuda', archivo: 'ayuda.png'),
        DefinicionPictograma(texto: 'Sí', archivo: 'si.png'),
        DefinicionPictograma(texto: 'No', archivo: 'no.png'),
      ],
    ),
    DefinicionCategoria(
      nombre: 'Emociones',
      orden: 1,
      pictogramas: <DefinicionPictograma>[
        DefinicionPictograma(texto: 'Feliz', archivo: 'feliz.png'),
        DefinicionPictograma(texto: 'Triste', archivo: 'triste.png'),
        DefinicionPictograma(texto: 'Enfadado', archivo: 'enfadado.png'),
        DefinicionPictograma(texto: 'Asustado', archivo: 'asustado.png'),
        DefinicionPictograma(texto: 'Cansado', archivo: 'cansado.png'),
        DefinicionPictograma(texto: 'Tranquilo', archivo: 'tranquilo.png'),
      ],
    ),
    DefinicionCategoria(
      nombre: 'Comida',
      orden: 2,
      pictogramas: <DefinicionPictograma>[
        DefinicionPictograma(texto: 'Hambre', archivo: 'hambre.png'),
        DefinicionPictograma(texto: 'Pan', archivo: 'pan.png'),
        DefinicionPictograma(texto: 'Leche', archivo: 'leche.png'),
        DefinicionPictograma(texto: 'Manzana', archivo: 'manzana.png'),
        DefinicionPictograma(texto: 'Plátano', archivo: 'platano.png'),
        DefinicionPictograma(texto: 'Arroz', archivo: 'arroz.png'),
      ],
    ),
    DefinicionCategoria(
      nombre: 'Actividades',
      orden: 3,
      pictogramas: <DefinicionPictograma>[
        DefinicionPictograma(texto: 'Jugar', archivo: 'jugar.png'),
        DefinicionPictograma(texto: 'Música', archivo: 'musica.png'),
        DefinicionPictograma(texto: 'Pintar', archivo: 'pintar.png'),
        DefinicionPictograma(texto: 'Leer', archivo: 'leer.png'),
        DefinicionPictograma(texto: 'Pelota', archivo: 'pelota.png'),
        DefinicionPictograma(texto: 'Ver televisión', archivo: 'television.png'),
      ],
    ),
  ];

  /// Número de categorías que define el catálogo base.
  static int get totalCategorias => catalogoBase.length;

  /// Número de pictogramas que define el catálogo base.
  static int get totalPictogramas =>
      catalogoBase.fold(0, (total, categoria) => total + categoria.pictogramas.length);

  /// Inserta el catálogo base si aún no ha sido sembrado.
  ///
  /// Devuelve `true` si esta llamada realizó la siembra y `false` si el catálogo ya
  /// existía. Toda la operación ocurre dentro de una transacción, de forma que el
  /// indicador de control nunca queda marcado con una siembra a medias.
  Future<bool> ejecutar() async {
    return _db.transaction(() async {
      if (await _yaInicializado()) {
        return false;
      }

      await _insertarCatalogo();
      await _marcarInicializado();
      return true;
    });
  }

  Future<bool> _yaInicializado() async {
    final consulta = _db.select(_db.configuracion)
      ..where((fila) => fila.clave.equals(ClavesConfiguracion.catalogoBaseInicializado));
    final fila = await consulta.getSingleOrNull();
    return fila?.valor == 'true';
  }

  Future<void> _insertarCatalogo() async {
    final categorias = <CategoriasCompanion>[];
    final pictogramas = <PictogramasCompanion>[];

    for (final definicionCategoria in catalogoBase) {
      final categoriaId = _uuid.v4();

      categorias.add(
        CategoriasCompanion.insert(
          id: categoriaId,
          nombre: definicionCategoria.nombre,
          esPredeterminada: const Value(true),
          activa: const Value(true),
          orden: Value(definicionCategoria.orden),
        ),
      );

      for (final definicionPictograma in definicionCategoria.pictogramas) {
        pictogramas.add(
          PictogramasCompanion.insert(
            id: _uuid.v4(),
            texto: definicionPictograma.texto,
            rutaImagen: '$_directorioBase/${definicionPictograma.archivo}',
            categoriaId: categoriaId,
            esPersonalizado: const Value(false),
            activo: const Value(true),
          ),
        );
      }
    }

    // Las categorías deben existir antes que los pictogramas por la clave foránea,
    // por lo que se usan dos lotes en lugar de uno solo.
    await _db.batch((batch) => batch.insertAll(_db.categorias, categorias));
    await _db.batch((batch) => batch.insertAll(_db.pictogramas, pictogramas));
  }

  Future<void> _marcarInicializado() async {
    await _db.into(_db.configuracion).insertOnConflictUpdate(
          ConfiguracionCompanion.insert(
            clave: ClavesConfiguracion.catalogoBaseInicializado,
            valor: 'true',
          ),
        );
  }
}

/// Descripción estática de una categoría predeterminada del catálogo base.
class DefinicionCategoria {
  const DefinicionCategoria({
    required this.nombre,
    required this.orden,
    required this.pictogramas,
  });

  final String nombre;
  final int orden;
  final List<DefinicionPictograma> pictogramas;
}

/// Descripción estática de un pictograma del catálogo base.
class DefinicionPictograma {
  const DefinicionPictograma({required this.texto, required this.archivo});

  final String texto;

  /// Nombre del archivo dentro de `assets/pictogramas/base/`.
  final String archivo;
}
