import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userTypeController = TextEditingController();

  bool _loading = false;
  bool _editMode = false;
  bool _changePassword = false;

  late String _originalName;
  late String _originalEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _loading = true);
    try {
      final userId = await AuthService.getLoggedUserId();
      final userData = await userService.fetchUser(userId!);

      if (userData != null) {
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _userTypeController.text = (userData['type'] ?? '').toLowerCase() == 'trainer'
            ? 'Entrenador'
            : 'Jugador';

        // Guardamos valores originales
        _originalName = _nameController.text;
        _originalEmail = _emailController.text;
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_changePassword &&
        _newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar('Las contraseñas no coinciden');
      return;
    }

    setState(() => _loading = true);
    try {
      final success = await userService.updateUser(
        name: _editMode ? _nameController.text : null,
        email: _editMode ? _emailController.text : null,
        currentPassword: _changePassword ? _currentPasswordController.text : null,
        newPassword: _changePassword ? _newPasswordController.text : null,
      );

      if (success) {
        _showSnackBar('Perfil actualizado con éxito');
        setState(() {
          _editMode = false;
          _changePassword = false;
          // Actualizamos valores originales
          _originalName = _nameController.text;
          _originalEmail = _emailController.text;
        });
      } else {
        _showSnackBar('Error al actualizar el perfil');
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _cancelChanges() {
    setState(() {
      _editMode = false;
      _changePassword = false;
      _nameController.text = _originalName;
      _emailController.text = _originalEmail;
    });
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    if (readOnly) {
      // Mostrar como campo no editable
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  controller.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Campo editable normal
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            border: const UnderlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ),
    );
  }


  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cambiar contraseña",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildTextField(
          label: 'Contraseña actual',
          controller: _currentPasswordController,
          readOnly: false,
          obscureText: true,
        ),
        _buildTextField(
          label: 'Nueva contraseña',
          controller: _newPasswordController,
          readOnly: false,
          obscureText: true,
        ),
        _buildTextField(
          label: 'Confirmar nueva contraseña',
          controller: _confirmPasswordController,
          readOnly: false,
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: ElevatedButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.check),
            label: const Text('Confirmar'),
          ),
        ),
        const SizedBox(width: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: OutlinedButton.icon(
            onPressed: _cancelChanges,
            icon: const Icon(Icons.close),
            label: const Text('Cancelar'),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final showActions = _editMode || _changePassword;

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: Text(
            'Perfil',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_editMode ? Icons.close : Icons.edit),
            tooltip: _editMode ? 'Cancelar edición' : 'Editar perfil',
            onPressed: () {
              setState(() {
                if (_editMode) {
                  _cancelChanges();
                } else {
                  _editMode = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.lock),
            tooltip: 'Cambiar contraseña',
            onPressed: () {
              setState(() => _changePassword = !_changePassword);
              if (!_changePassword) {
                _currentPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              }
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Información de perfil",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTextField(
                    label: 'Nombre y apellido',
                    controller: _nameController,
                    readOnly: !_editMode,
                  ),
                  _buildTextField(
                    label: 'Email',
                    controller: _emailController,
                    readOnly: !_editMode,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    label: 'Tipo de usuario',
                    controller: _userTypeController,
                    readOnly: true,
                  ),
                  if (_changePassword) ...[
                    const Divider(height: 32),
                    _buildPasswordSection(),
                  ],
                  if (showActions) ...[
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _userTypeController.dispose();
    super.dispose();
  }
}


