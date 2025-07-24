import 'package:flutter/material.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/services/config_service.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final success = await AuthService.login(_username, _password);

      if (success) {
        final userConfig = await ConfigService.getUserConfig();
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        await themeProvider.initFromConfig(userConfig);
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales inválidas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Usuario'),
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Ingresá un usuario' : null,
            onSaved: (value) => _username = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Ingresá la contraseña' : null,
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('Ingresar'),
            ),
          ),
        ],
      ),
    );
  }
}


