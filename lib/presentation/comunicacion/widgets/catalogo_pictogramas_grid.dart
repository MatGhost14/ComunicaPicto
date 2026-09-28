import 'package:material_ui/material_ui.dart';

import '../../../domain/entities/categoria_con_pictogramas.dart';
import 'pictograma_card.dart';

/// Cuadrícula de dos columnas con los pictogramas del catálogo, agrupados
/// visualmente por categoría.
///
/// Cada categoría aporta un encabezado fijo y su propia cuadrícula, de modo que el
/// desplazamiento es continuo a lo largo de todo el catálogo.
class CatalogoPictogramasGrid extends StatelessWidget {
  const CatalogoPictogramasGrid({super.key, required this.categorias});

  final List<CategoriaConPictogramas> categorias;

  static const int _columnas = 2;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        for (final grupo in categorias) ...[
          SliverPersistentHeader(
            pinned: true,
            delegate: _EncabezadoCategoria(nombre: grupo.categoria.nombre),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _columnas,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, indice) => PictogramaCard(pictograma: grupo.pictogramas[indice]),
                childCount: grupo.pictogramas.length,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Encabezado de categoría que permanece fijo mientras se recorre su cuadrícula.
class _EncabezadoCategoria extends SliverPersistentHeaderDelegate {
  const _EncabezadoCategoria({required this.nombre});

  final String nombre;

  static const double _altura = 48;

  @override
  double get minExtent => _altura;

  @override
  double get maxExtent => _altura;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);

    return Container(
      height: _altura,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Text(
        nombre,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _EncabezadoCategoria oldDelegate) => oldDelegate.nombre != nombre;
}
