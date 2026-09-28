import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/pictograma_repository.dart';
import '../viewmodels/catalogo_viewmodel.dart';
import '../widgets/catalogo_pictogramas_grid.dart';

/// Pantalla del módulo de Comunicación que muestra el catálogo de pictogramas
/// agrupado por categoría.
///
/// Verifica el criterio de aceptación 2 de la HU1: las categorías predeterminadas
/// quedan visibles sin ninguna configuración adicional por parte del adulto.
class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({
    super.key,
    required this.repository,
    required this.nombrePerfil,
  });

  final PictogramaRepository repository;
  final String nombrePerfil;

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  late final CatalogoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CatalogoViewModel(widget.repository);
    _viewModel.cargar();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Comunicación'),
            Text(
              widget.nombrePerfil,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.cargando) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_viewModel.error != null) {
              return _Mensaje(
                icono: Icons.error_outline,
                texto: _viewModel.error!,
                accion: FilledButton(
                  onPressed: _viewModel.cargar,
                  child: const Text('Reintentar'),
                ),
              );
            }

            if (_viewModel.vacio) {
              return const _Mensaje(
                icono: Icons.grid_off_outlined,
                texto: 'Todavía no hay pictogramas en el catálogo.',
              );
            }

            return CatalogoPictogramasGrid(categorias: _viewModel.categorias);
          },
        ),
      ),
    );
  }
}

class _Mensaje extends StatelessWidget {
  const _Mensaje({required this.icono, required this.texto, this.accion});

  final IconData icono;
  final String texto;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(texto, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (accion != null) ...[const SizedBox(height: 16), accion!],
          ],
        ),
      ),
    );
  }
}
