import 'package:flutter/material.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/services/config_service.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:go_router/go_router.dart';
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
        context.go('/home');
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Ya sos usuario?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Ingresá un usuario' : null,
            onSaved: (value) => _username = value ?? '',
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Ingresá la contraseña' : null,
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 24),


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


