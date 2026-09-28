import 'package:comunicapicto/data/database/app_database.dart';
import 'package:comunicapicto/data/database/seed_catalogo_base.dart';
import 'package:comunicapicto/data/repositories/perfil_repository.dart';
import 'package:comunicapicto/data/repositories/pictograma_repository.dart';
// `show Value` evita el choque entre los matchers de test y los ayudantes SQL que
// drift exporta con los mismos nombres (`isNull`, `isNotNull`).
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pruebas de la HU1: carga automática del catálogo base al crear un perfil.
///
/// Usan una base de datos Drift en memoria, de modo que no tocan el dispositivo ni la
/// red.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.conEjecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('SeedCatalogoBase', () {
    test('inserta la cantidad exacta de categorías y pictogramas definida', () async {
      final sembrado = await SeedCatalogoBase(db).ejecutar();

      expect(sembrado, isTrue);
      expect(await db.select(db.categorias).get(), hasLength(SeedCatalogoBase.totalCategorias));
      expect(await db.select(db.pictogramas).get(), hasLength(SeedCatalogoBase.totalPictogramas));
    });

    test('el catálogo base define 4 categorías y 24 pictogramas', () {
      expect(SeedCatalogoBase.totalCategorias, 4);
      expect(SeedCatalogoBase.totalPictogramas, 24);
    });

    test('una segunda ejecución no duplica los datos', () async {
      expect(await SeedCatalogoBase(db).ejecutar(), isTrue);
      expect(await SeedCatalogoBase(db).ejecutar(), isFalse);

      expect(await db.select(db.categorias).get(), hasLength(SeedCatalogoBase.totalCategorias));
      expect(await db.select(db.pictogramas).get(), hasLength(SeedCatalogoBase.totalPictogramas));
    });

    test('marca el indicador catalogoBaseInicializado', () async {
      final consulta = db.select(db.configuracion)
        ..where((fila) => fila.clave.equals(ClavesConfiguracion.catalogoBaseInicializado));

      expect(await consulta.getSingleOrNull(), isNull);

      await SeedCatalogoBase(db).ejecutar();

      expect((await consulta.getSingle()).valor, 'true');
    });

    test('todas las categorías sembradas son predeterminadas y están activas', () async {
      await SeedCatalogoBase(db).ejecutar();

      final categorias = await db.select(db.categorias).get();
      expect(categorias.every((c) => c.esPredeterminada), isTrue);
      expect(categorias.every((c) => c.activa), isTrue);
      expect(
        categorias.map((c) => c.nombre),
        containsAll(<String>['Necesidades básicas', 'Emociones', 'Comida', 'Actividades']),
      );
    });

    test('los pictogramas no son personalizados y apuntan a assets locales', () async {
      await SeedCatalogoBase(db).ejecutar();

      final pictogramas = await db.select(db.pictogramas).get();
      expect(pictogramas.every((p) => !p.esPersonalizado), isTrue);
      expect(pictogramas.every((p) => p.activo), isTrue);
      expect(
        pictogramas.every((p) => p.rutaImagen.startsWith('assets/pictogramas/base/')),
        isTrue,
        reason: 'El catálogo debe estar incorporado localmente, nunca descargado.',
      );
    });

    test('cada pictograma pertenece a una categoría existente', () async {
      await SeedCatalogoBase(db).ejecutar();

      final idsCategorias = (await db.select(db.categorias).get()).map((c) => c.id).toSet();
      final pictogramas = await db.select(db.pictogramas).get();

      expect(pictogramas.every((p) => idsCategorias.contains(p.categoriaId)), isTrue);
    });
  });

  group('PerfilRepository.crearPerfil', () {
    test('siembra el catálogo base automáticamente al crear el primer perfil', () async {
      final perfil = await PerfilRepository(db).crearPerfil('Martín');

      expect(perfil.nombre, 'Martín');
      expect(await db.select(db.categorias).get(), hasLength(SeedCatalogoBase.totalCategorias));
      expect(await db.select(db.pictogramas).get(), hasLength(SeedCatalogoBase.totalPictogramas));
    });

    test('crear un segundo perfil no vuelve a insertar el catálogo', () async {
      final repository = PerfilRepository(db);
      await repository.crearPerfil('Martín');
      await repository.crearPerfil('Sofía');

      expect(await db.select(db.perfiles).get(), hasLength(2));
      expect(await db.select(db.categorias).get(), hasLength(SeedCatalogoBase.totalCategorias));
      expect(await db.select(db.pictogramas).get(), hasLength(SeedCatalogoBase.totalPictogramas));
    });

    test('rechaza un nombre vacío', () async {
      expect(() => PerfilRepository(db).crearPerfil('   '), throwsArgumentError);
    });
  });

  group('PictogramaRepository.obtenerActivosPorCategoria', () {
    test('devuelve el catálogo agrupado y ordenado por categoría', () async {
      await PerfilRepository(db).crearPerfil('Martín');

      final grupos = await PictogramaRepository(db).obtenerActivosPorCategoria();

      expect(grupos, hasLength(SeedCatalogoBase.totalCategorias));
      expect(
        grupos.map((g) => g.categoria.nombre),
        <String>['Necesidades básicas', 'Emociones', 'Comida', 'Actividades'],
      );
      expect(
        grupos.fold<int>(0, (total, g) => total + g.pictogramas.length),
        SeedCatalogoBase.totalPictogramas,
      );
    });

    test('omite los pictogramas y las categorías inactivas', () async {
      await PerfilRepository(db).crearPerfil('Martín');

      final emociones = await (db.select(db.categorias)
            ..where((fila) => fila.nombre.equals('Emociones')))
          .getSingle();

      await (db.update(db.categorias)..where((fila) => fila.id.equals(emociones.id)))
          .write(const CategoriasCompanion(activa: Value(false)));

      final grupos = await PictogramaRepository(db).obtenerActivosPorCategoria();

      expect(grupos, hasLength(SeedCatalogoBase.totalCategorias - 1));
      expect(grupos.map((g) => g.categoria.nombre), isNot(contains('Emociones')));
    });
  });
}
