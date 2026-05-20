import 'package:email_validator/email_validator.dart';

// Extract validators as testable functions
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }

  final email = value.trim();

  if (!EmailValidator.validate(email)) {
    return 'Invalid email';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password is required';
  }

  final password = value.trim();

  if (password.length < 8) {
    return 'Min 8 characters';
  }

  return null;
}
