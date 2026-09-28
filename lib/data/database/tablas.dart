import 'package:drift/drift.dart';

/// Definición de las tablas Drift del módulo de Comunicación (HU1).
///
/// Todas las entidades usan UUID v4 en una columna de texto como llave primaria;
/// el proyecto no utiliza enteros autoincrementales en ningún caso.
///
/// Las clases de fila generadas llevan el sufijo `Row` para no colisionar con los
/// modelos de dominio de `lib/domain/entities/`, que son los que cruzan hacia la
/// capa de presentación.

/// Categorías que agrupan a los pictogramas.
///
/// Las categorías del catálogo base se insertan con [esPredeterminada] en `true`.
/// La HU4 usará ese campo para impedir que el adulto las edite o elimine; se define
/// desde ahora para no requerir una migración posterior.
@DataClassName('CategoriaRow')
class Categorias extends Table {
  TextColumn get id => text()();

  TextColumn get nombre => text().withLength(min: 1, max: 60)();

  BoolColumn get esPredeterminada => boolean().withDefault(const Constant(false))();

  BoolColumn get activa => boolean().withDefault(const Constant(true))();

  /// Orden de presentación en el módulo de Comunicación.
  ///
  /// Se incluye desde la versión 1 del esquema para que el orden de las categorías
  /// sea estable y configurable sin una migración futura.
  IntColumn get orden => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Pictogramas del catálogo. Relación 1:N Categoría → Pictograma.
///
/// Los pictogramas del catálogo base se insertan con [esPersonalizado] en `false`
/// y su [rutaImagen] apunta a un asset incorporado en la app, nunca a una URL:
/// el catálogo debe estar disponible sin conexión a Internet.
@DataClassName('PictogramaRow')
class Pictogramas extends Table {
  TextColumn get id => text()();

  TextColumn get texto => text().withLength(min: 1, max: 80)();

  TextColumn get rutaImagen => text()();

  TextColumn get categoriaId => text().references(Categorias, #id)();

  BoolColumn get esPersonalizado => boolean().withDefault(const Constant(false))();

  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Perfiles de los niños que usan la aplicación.
///
/// Esquema mínimo para la HU1; se ampliará en las historias de Rutinas y Mis Logros.
@DataClassName('PerfilRow')
class Perfiles extends Table {
  TextColumn get id => text()();

  TextColumn get nombre => text().withLength(min: 1, max: 60)();

  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  DateTimeColumn get creadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Configuración interna de la aplicación, como pares clave/valor.
///
/// Guarda, entre otros, el indicador `catalogoBaseInicializado`, que evita volver a
/// insertar el catálogo base cada vez que se crea un perfil.
@DataClassName('ConfiguracionRow')
class Configuracion extends Table {
  TextColumn get clave => text()();

  TextColumn get valor => text()();

  @override
  Set<Column> get primaryKey => {clave};
}
