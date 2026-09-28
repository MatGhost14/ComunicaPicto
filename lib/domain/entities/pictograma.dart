/// Pictograma perteneciente a una categoría.
///
/// [rutaImagen] siempre apunta a un asset local incorporado en la aplicación
/// (por ejemplo `assets/pictogramas/base/agua.png`), nunca a una URL remota: el
/// catálogo debe funcionar sin conexión a Internet.
class Pictograma {
  const Pictograma({
    required this.id,
    required this.texto,
    required this.rutaImagen,
    required this.categoriaId,
    required this.esPersonalizado,
    required this.activo,
  });

  /// UUID v4.
  final String id;

  /// Texto asociado al pictograma; será el que se locute mediante TTS en la HU3.
  final String texto;

  final String rutaImagen;

  /// UUID de la categoría a la que pertenece (relación 1:N Categoría → Pictograma).
  final String categoriaId;

  /// `false` para los pictogramas del catálogo base.
  final bool esPersonalizado;

  final bool activo;
}
