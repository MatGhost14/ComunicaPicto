import 'package:comunicapicto/data/database/app_database.dart';
import 'package:comunicapicto/data/repositories/perfil_repository.dart';
import 'package:comunicapicto/data/repositories/pictograma_repository.dart';
import 'package:comunicapicto/presentation/comunicacion/screens/catalogo_screen.dart';
import 'package:comunicapicto/presentation/comunicacion/widgets/catalogo_pictogramas_grid.dart';
import 'package:comunicapicto/presentation/comunicacion/widgets/pictograma_card.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Verifica el criterio de aceptación 2 de la HU1: tras crear un perfil, las
/// categorías predeterminadas quedan visibles en el módulo de Comunicación sin ninguna
/// configuración adicional.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.conEjecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> mostrarCatalogo(WidgetTester tester) async {
    await PerfilRepository(db).crearPerfil('Martín');

    await tester.pumpWidget(
      MaterialApp(
        home: CatalogoScreen(
          repository: PictogramaRepository(db),
          nombrePerfil: 'Martín',
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('muestra las categorías predeterminadas sin configuración previa', (tester) async {
    await mostrarCatalogo(tester);

    expect(find.byType(CatalogoPictogramasGrid), findsOneWidget);
    expect(find.text('Necesidades básicas'), findsOneWidget);
  });

  testWidgets('la cuadrícula es de dos columnas', (tester) async {
    await mostrarCatalogo(tester);

    final grid = tester.widget<SliverGrid>(find.byType(SliverGrid).first);
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisCount, 2);
  });

  testWidgets('presenta los pictogramas de la primera categoría', (tester) async {
    await mostrarCatalogo(tester);

    expect(find.byType(PictogramaCard), findsWidgets);
    expect(find.text('Agua'), findsOneWidget);
    expect(find.text('Ayuda'), findsOneWidget);
  });
}
