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

  final List<String> _positions = ['DEFENCE', 'MIDFIELD', 'FORWARD'];

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
      print(success);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        context.go('/login');
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
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'TRAINEE', child: Text('Trainee')),
                  DropdownMenuItem(value: 'COACH', child: Text('Coach')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _selectedPosition = null; // resetear
                  });
                },
                decoration: const InputDecoration(labelText: "Tipo"),
              ),
              const SizedBox(height: 16),
              if (_selectedType == 'TRAINEE')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Posición:"),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _positions.map((position) {
                        final selected = _selectedPosition == position;
                        return ChoiceChip(
                          label: Text(position),
                          selected: selected,
                          onSelected: (value) {
                            setState(() {
                              _selectedPosition =
                              value ? position : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


