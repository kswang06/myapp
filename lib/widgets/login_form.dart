import 'package:flutter/material.dart';
import 'package:myapp/validators/login_validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  bool submitted = false;

  void submit() {
    final isValid = formKey.currentState!.validate();

    setState(() {
      submitted = isValid;
    });
  }

  void clearSubmitted() {
    if (submitted) {
      setState(() {
        submitted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            onChanged: (_) => clearSubmitted(),
            validator: validateEmail,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (_) => clearSubmitted(),
            validator: validatePassword,
          ),
          ElevatedButton(onPressed: submit, child: const Text('Login')),
          if (submitted) const Text('Submitted'),
        ],
      ),
    );
  }
}
