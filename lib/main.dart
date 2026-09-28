import 'package:material_ui/material_ui.dart';

import 'data/database/app_database.dart';
import 'data/repositories/perfil_repository.dart';
import 'data/repositories/pictograma_repository.dart';
import 'presentation/comunicacion/screens/crear_perfil_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ComunicaPictoApp(database: AppDatabase()));
}

/// Raíz de la aplicación.
///
/// Construye la base de datos y los repositorios una sola vez y los inyecta hacia las
/// pantallas. La HU1 arranca en la creación de perfil, que es lo que dispara la carga
/// automática del catálogo base.
class ComunicaPictoApp extends StatefulWidget {
  const ComunicaPictoApp({super.key, required this.database});

  final AppDatabase database;

  @override
  State<ComunicaPictoApp> createState() => _ComunicaPictoAppState();
}

class _ComunicaPictoAppState extends State<ComunicaPictoApp> {
  late final PerfilRepository _perfilRepository;
  late final PictogramaRepository _pictogramaRepository;

  @override
  void initState() {
    super.initState();
    _perfilRepository = PerfilRepository(widget.database);
    _pictogramaRepository = PictogramaRepository(widget.database);
  }

  @override
  void dispose() {
    widget.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComunicaPicto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
      ),
      home: CrearPerfilScreen(
        perfilRepository: _perfilRepository,
        pictogramaRepository: _pictogramaRepository,
      ),
    );
  }
}
