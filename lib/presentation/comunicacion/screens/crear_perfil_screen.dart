import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/perfil_repository.dart';
import '../../../data/repositories/pictograma_repository.dart';
import '../viewmodels/crear_perfil_viewmodel.dart';
import 'catalogo_screen.dart';

/// Pantalla de creación de perfil.
///
/// Al confirmar, el repositorio crea el perfil y siembra automáticamente el catálogo
/// base, tras lo cual se navega directamente al módulo de Comunicación.
class CrearPerfilScreen extends StatefulWidget {
  const CrearPerfilScreen({
    super.key,
    required this.perfilRepository,
    required this.pictogramaRepository,
  });

  final PerfilRepository perfilRepository;
  final PictogramaRepository pictogramaRepository;

  @override
  State<CrearPerfilScreen> createState() => _CrearPerfilScreenState();
}

class _CrearPerfilScreenState extends State<CrearPerfilScreen> {
  late final CrearPerfilViewModel _viewModel;
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = CrearPerfilViewModel(widget.perfilRepository);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _crearPerfil() async {
    final perfil = await _viewModel.crearPerfil(_nombreController.text);
    if (perfil == null || !mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CatalogoScreen(
          repository: widget.pictogramaRepository,
          nombrePerfil: perfil.nombre,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo perfil')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Crea el perfil del niño o niña',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'El catálogo de pictogramas se cargará automáticamente, '
                        'sin necesidad de configurarlo.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _nombreController,
                        enabled: !_viewModel.guardando,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _crearPerfil(),
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          border: const OutlineInputBorder(),
                          errorText: _viewModel.error,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _viewModel.guardando ? null : _crearPerfil,
                        child: _viewModel.guardando
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Crear perfil'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
