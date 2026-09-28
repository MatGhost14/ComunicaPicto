import 'package:material_ui/material_ui.dart';

import '../../../domain/entities/pictograma.dart';

/// Celda individual del catálogo: la imagen del pictograma y su texto.
///
/// En la HU1 la tarjeta es sólo de presentación; la selección hacia la barra de
/// comunicación corresponde a la HU2.
class PictogramaCard extends StatelessWidget {
  const PictogramaCard({super.key, required this.pictograma});

  final Pictograma pictograma;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Semantics(
                image: true,
                label: pictograma.texto,
                child: Image.asset(
                  pictograma.rutaImagen,
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pictograma.texto,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
