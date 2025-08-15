import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/user_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  final userService = UserService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _userType = '';
  List<dynamic> _teams = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _loading = true);
    final userId = await _storage.read(key: 'user_id');
    final userData = await userService.fetchUser(userId!);

    if (userData != null) {
      _nameController.text = userData['name'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _userType = userData['type'] ?? '';
      _teams = userData['teams'] ?? [];
    }

    setState(() => _loading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final changingPassword = _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;

    if (changingPassword &&
        _newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _loading = true);

    final success = await userService.updateUser(
      name: _nameController.text.isEmpty ? null : _nameController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      currentPassword: changingPassword ? _currentPasswordController.text : null,
      newPassword: changingPassword ? _newPasswordController.text : null,
    );

    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre y apellido'),
                validator: (value) =>
                value!.isEmpty ? 'Ingrese su nombre completo' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value!.isEmpty ? 'Ingrese su email' : null,
              ),
              TextFormField(
                initialValue: _userType,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tipo de usuario'),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                'Cambio de contraseña (opcional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(labelText: 'Contraseña actual'),
                obscureText: true,
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirmar nueva contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


