/// Perfil del niño o niña que utiliza la aplicación.
///
/// Esquema mínimo para la HU1; las historias de Rutinas y Mis Logros lo ampliarán.
class Perfil {
  const Perfil({
    required this.id,
    required this.nombre,
    required this.activo,
    required this.creadoEn,
  });

  /// UUID v4.
  final String id;

  final String nombre;

  final bool activo;

  final DateTime creadoEn;
}
