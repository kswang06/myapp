import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/validators/login_validators.dart';
import 'package:myapp/widgets/login_form.dart';

void main() {
  group('validateEmail', () {
    test('returns error for null input', () {
      expect(validateEmail(null), 'Email is required');
    });

    test('returns error for empty input', () {
      expect(validateEmail(''), 'Email is required');
    });

    test('returns error for whitespace input', () {
      expect(validateEmail('   '), 'Email is required');
    });

    test('returns error for invalid format', () {
      expect(validateEmail('not_an_email'), 'Invalid email');
    });

    test('returns error for missing domain', () {
      expect(validateEmail('user@'), 'Invalid email');
    });

    test('returns error for missing @', () {
      expect(validateEmail('userexample.com'), 'Invalid email');
    });

    test('returns null for valid email', () {
      expect(validateEmail('user@example.com'), isNull);
    });

    test('returns null for valid email with surrounding spaces', () {
      expect(validateEmail('  user@example.com  '), isNull);
    });

    test('returns error for email missing header', () {
      expect(validateEmail('@example.com'), 'Invalid email');
    });
  });

  group('validatePassword', () {
    test('returns error for null input', () {
      expect(validatePassword(null), 'Password is required');
    });

    test('returns error for empty input', () {
      expect(validatePassword(''), 'Password is required');
    });

    test('returns error for whitespace input', () {
      expect(validatePassword('   '), 'Password is required');
    });

    test('returns error for fewer than 8 characters', () {
      expect(validatePassword('1234567'), 'Min 8 characters');
    });

    test('returns null for valid password', () {
      expect(validatePassword('12345678'), isNull);
    });

    test('returns null for password with more than 8 chars', () {
      expect(validatePassword('123456789'), isNull);
    });
  });

  group('LoginForm', () {
    testWidgets('Submitted is not shown before submit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Material(child: LoginForm())),
      );

      expect(find.text('Submitted'), findsNothing);
    });

    testWidgets('submit button is present and labelled Login', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Material(child: LoginForm())),
      );

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('tapping submit with empty fields shows validation messages', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Material(child: LoginForm())),
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Submitted is not shown after invalid submit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Material(child: LoginForm())),
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Submitted'), findsNothing);
    });

    testWidgets(
      'tapping submit with invalid fields shows validation messages',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Material(child: LoginForm())),
        );

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'not-an-email',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '1234567');
        await tester.tap(find.text('Login'));
        await tester.pump();

        expect(find.text('Invalid email'), findsOneWidget);
        expect(find.text('Min 8 characters'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping submit with invalid password shows validation messages',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Material(child: LoginForm())),
        );

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'user@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '1234567');
        await tester.tap(find.text('Login'));
        await tester.pump();

        expect(find.text('Invalid email'), findsNothing);
        expect(find.text('Min 8 characters'), findsOneWidget);
      },
    );

    testWidgets('tapping submit with invalid email shows validation messages', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Material(child: LoginForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
      await tester.enterText(find.byType(TextFormField).at(1), '12345678');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Min 8 characters'), findsNothing);
    });

    testWidgets('tapping submit with valid fields shows Submitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Material(child: LoginForm())),
      );

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Submitted'), findsOneWidget);
    });

    testWidgets('Submitted is null when a submitted form has invalid fields', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Material(child: LoginForm())),
      );

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Submitted'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
      await tester.pump();

      expect(find.text('Submitted'), findsNothing);
    });
  });
}
