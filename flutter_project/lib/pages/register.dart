import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String _selectedType = 'TRAINEE';
  String? _selectedPosition;

  final Map<String, String> _positionLabels = {
    'DEFENCE': 'Defensor',
    'MIDFIELD': 'Mediocampista',
    'FORWARD': 'Delantero',
  };

  String getPositionLabel(String value) {
    return _positionLabels[value] ?? value;
  }

  String getPositionValue(String label) {
    return _positionLabels.entries
        .firstWhere(
          (entry) => entry.value == label,
      orElse: () => const MapEntry('UNKNOWN', 'Desconocido'),
    )
        .key;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final requestBody = {
        "name": _nameCtrl.text,
        "email": _emailCtrl.text,
        "password": _passwordCtrl.text,
        "type": _selectedType,
      };

      if (_selectedType == 'TRAINEE' && _selectedPosition != null) {
        requestBody["position"] = _selectedPosition!;
      }

      final success = await AuthService.register(requestBody);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        final loginSuccess = await AuthService.login(
          _emailCtrl.text,
          _passwordCtrl.text,
        );
        if (loginSuccess) {
          if (!mounted) return;
          context.go('/home');
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al iniciar sesión')),
          );
          context.go('/');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 800;

          if (isNarrow) {
            // Pantalla pequeña (móvil)
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'web/icons/logo2.png',
                        height: 120, // un poco más pequeño en móvil
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => context.go('/'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Registro",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: "Nombre",
                                helperText: "Ej: Juan Pérez",
                              ),
                              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                helperText: "Ej: ejemplo@correo.com",
                              ),
                              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Contraseña",
                                helperText: "Ej: 1234",
                              ),
                              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                            const SizedBox(height: 24),
                            DropdownButtonFormField<String>(
                              value: _selectedType,
                              items: const [
                                DropdownMenuItem(value: 'TRAINEE', child: Text('Jugador')),
                                DropdownMenuItem(value: 'TRAINER', child: Text('Entrenador')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                  _selectedPosition = null;
                                });
                              },
                              decoration: const InputDecoration(labelText: "Tipo"),
                            ),
                            const SizedBox(height: 24),
                            if (_selectedType == 'TRAINEE')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Posición:"),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    children: _positionLabels.keys.map((position) {
                                      final selected = _selectedPosition == position;
                                      return ChoiceChip(
                                        label: Text(getPositionLabel(position)),
                                        selected: selected,
                                        onSelected: (value) {
                                          setState(() {
                                            _selectedPosition = value ? position : null;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text("Registrarse"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Pantalla grande (desktop)
            return Row(
              children: [
                Container(
                  width: 200,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'web/icons/logo2.png',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 650),
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => context.go('/'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Registro",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: "Nombre",
                                helperText: "Ej: Juan Pérez",
                              ),
                              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                helperText: "Ej: ejemplo@correo.com",
                              ),
                              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Contraseña",
                                helperText: "Ej: 1234",
                              ),
                              validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                            const SizedBox(height: 32),
                            DropdownButtonFormField<String>(
                              value: _selectedType,
                              items: const [
                                DropdownMenuItem(value: 'TRAINEE', child: Text('Jugador')),
                                DropdownMenuItem(value: 'TRAINER', child: Text('Entrenador')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                  _selectedPosition = null;
                                });
                              },
                              decoration: const InputDecoration(labelText: "Tipo"),
                            ),
                            const SizedBox(height: 32),
                            if (_selectedType == 'TRAINEE')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Posición:"),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    children: _positionLabels.keys.map((position) {
                                      final selected = _selectedPosition == position;
                                      return ChoiceChip(
                                        label: Text(getPositionLabel(position)),
                                        selected: selected,
                                        onSelected: (value) {
                                          setState(() {
                                            _selectedPosition = value ? position : null;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                              ),
                              child: const Text("Registrarse"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }


}




