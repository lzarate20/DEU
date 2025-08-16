import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final _userTypeController = TextEditingController();

  bool _loading = false;
  bool _editMode = false;
  bool _changePassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _loading = true);
    try {
      final userId = await _storage.read(key: 'user_id');
      final userData = await userService.fetchUser(userId!);

      if (userData != null) {
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _userTypeController.text = userData['type'] ?? '';
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_changePassword &&
        _newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito')),
        );
        setState(() {
          _editMode = false;
          _changePassword = false;
        });
        _loadUserData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el perfil')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _cancelChanges() {
    setState(() {
      _editMode = false;
      _changePassword = false;
    });
    _loadUserData(); // vuelve a cargar datos originales
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  Widget _buildCompactField({
    required String label,
    required TextEditingController controller,
    bool editable = true,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: TextFormField(
          controller: controller,
          enabled: editable,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            disabledBorder: UnderlineInputBorder(),
          ).copyWith(labelText: label),
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: (value) {
            if (!editable) return null;
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _passwordFields() {
    return Column(
      children: [
        _buildCompactField(
          label: 'Contraseña actual',
          controller: _currentPasswordController,
          obscureText: true,
        ),
        _buildCompactField(
          label: 'Nueva contraseña',
          controller: _newPasswordController,
          obscureText: true,
        ),
        _buildCompactField(
          label: 'Confirmar nueva contraseña',
          controller: _confirmPasswordController,
          obscureText: true,
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    final showActions = _editMode || _changePassword;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar perfil',
            onPressed: () {
              setState(() => _editMode = true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.lock),
            tooltip: 'Cambiar contraseña',
            onPressed: () {
              setState(() => _changePassword = !_changePassword);
              if (!_changePassword) {
                // si cierra la sección, limpiar campos
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
                  _buildCompactField(
                    label: 'Nombre y apellido',
                    controller: _nameController,
                    editable: _editMode,
                  ),
                  _buildCompactField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    editable: _editMode,
                  ),
                  _buildCompactField(
                    label: 'Tipo de usuario',
                    controller: _userTypeController,
                    editable: false,
                  ),
                  if (_changePassword) ...[
                    const Divider(),
                    _passwordFields(),
                  ],
                  if (showActions) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints:
                          const BoxConstraints(maxWidth: 150),
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            child: const Text('Confirmar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ConstrainedBox(
                          constraints:
                          const BoxConstraints(maxWidth: 150),
                          child: OutlinedButton(
                            onPressed: _cancelChanges,
                            child: const Text('Cancelar'),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}








