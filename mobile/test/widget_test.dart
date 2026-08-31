import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  group('PrepLoop Authentication Tests', () {
    // ========================================================================
    // TEST 1: LOGIN PAGE
    // ========================================================================

    testWidgets(
      'Login page loads correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PrepLoopApp());
        await tester.pumpAndSettle();

        expect(find.text('PrepLoop'), findsOneWidget);

        expect(find.text('Build Skills.'), findsOneWidget);
        expect(find.text('Ace Interviews.'), findsOneWidget);
        expect(find.text('Launch Your Career.'), findsOneWidget);

        expect(
          find.text(
            'PrepLoop is your all-in-one platform to prepare, '
            'practice and get placed in your dream job.',
          ),
          findsOneWidget,
        );

        expect(find.text('Welcome Back!'), findsOneWidget);

        expect(
          find.text(
            'Login to continue your learning journey',
          ),
          findsOneWidget,
        );

        expect(find.text('Email Address'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);

        expect(find.text('Forgot Password?'), findsOneWidget);
        expect(find.text('Remember me'), findsOneWidget);

        expect(
          find.widgetWithText(
            ElevatedButton,
            'Login',
          ),
          findsOneWidget,
        );

        expect(
          find.text('Continue with Google'),
          findsOneWidget,
        );

        expect(
          find.text('Continue with Apple'),
          findsOneWidget,
        );

        expect(find.text('New here?'), findsOneWidget);

        expect(
          find.widgetWithText(
            TextButton,
            'Register',
          ),
          findsOneWidget,
        );
      },
    );

    // ========================================================================
    // TEST 2: LOGIN -> REGISTER
    // ========================================================================

    testWidgets(
      'Register page opens when Register is clicked',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PrepLoopApp());
        await tester.pumpAndSettle();

        expect(
          find.text('Welcome Back!'),
          findsOneWidget,
        );

        final Finder registerButton = find.widgetWithText(
          TextButton,
          'Register',
        );

        expect(
          registerButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          registerButton,
        );

        await tester.tap(
          registerButton,
        );

        await tester.pumpAndSettle();

        // Heading + button.
        expect(
          find.text('Create Account'),
          findsNWidgets(2),
        );

        expect(
          find.text(
            'Create your PrepLoop account and start your journey.',
          ),
          findsOneWidget,
        );

        expect(
          find.text('Full Name'),
          findsOneWidget,
        );

        expect(
          find.text('Email Address'),
          findsOneWidget,
        );

        expect(
          find.text('Password'),
          findsOneWidget,
        );

        expect(
          find.text('Confirm Password'),
          findsOneWidget,
        );

        expect(
          find.widgetWithText(
            ElevatedButton,
            'Create Account',
          ),
          findsOneWidget,
        );

        expect(
          find.widgetWithText(
            TextButton,
            'Login',
          ),
          findsOneWidget,
        );
      },
    );

    // ========================================================================
    // TEST 3: REGISTER -> LOGIN
    // ========================================================================

    testWidgets(
      'Login page opens from Register page',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PrepLoopApp());
        await tester.pumpAndSettle();

        final Finder registerButton = find.widgetWithText(
          TextButton,
          'Register',
        );

        expect(
          registerButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          registerButton,
        );

        await tester.tap(
          registerButton,
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Create Account'),
          findsNWidgets(2),
        );

        expect(
          find.text('Full Name'),
          findsOneWidget,
        );

        final Finder loginButton = find.widgetWithText(
          TextButton,
          'Login',
        );

        expect(
          loginButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          loginButton,
        );

        await tester.tap(
          loginButton,
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Welcome Back!'),
          findsOneWidget,
        );

        expect(
          find.text(
            'Login to continue your learning journey',
          ),
          findsOneWidget,
        );

        expect(
          find.text('Email Address'),
          findsOneWidget,
        );

        expect(
          find.text('Password'),
          findsOneWidget,
        );
      },
    );

    // ========================================================================
    // TEST 4: LOGIN VALIDATION
    // ========================================================================

    testWidgets(
      'Login form validates empty fields',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PrepLoopApp());
        await tester.pumpAndSettle();

        final Finder loginButton = find.widgetWithText(
          ElevatedButton,
          'Login',
        );

        expect(
          loginButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          loginButton,
        );

        await tester.tap(
          loginButton,
        );

        await tester.pump();

        expect(
          find.text('Email is required'),
          findsOneWidget,
        );

        expect(
          find.text('Password is required'),
          findsOneWidget,
        );
      },
    );

    // ========================================================================
    // TEST 5: REGISTER VALIDATION
    // ========================================================================

    testWidgets(
      'Register form validates empty fields',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PrepLoopApp());
        await tester.pumpAndSettle();

        final Finder registerButton = find.widgetWithText(
          TextButton,
          'Register',
        );

        expect(
          registerButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          registerButton,
        );

        await tester.tap(
          registerButton,
        );

        await tester.pumpAndSettle();

        final Finder createAccountButton = find.widgetWithText(
          ElevatedButton,
          'Create Account',
        );

        expect(
          createAccountButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          createAccountButton,
        );

        await tester.tap(
          createAccountButton,
        );

        await tester.pump();

        expect(
          find.text('Name is required'),
          findsOneWidget,
        );

        expect(
          find.text('Email is required'),
          findsOneWidget,
        );

        expect(
          find.text('Password is required'),
          findsOneWidget,
        );

        expect(
          find.text('Please confirm your password'),
          findsOneWidget,
        );
      },
    );

    // ========================================================================
    // TEST 6: PASSWORD MISMATCH
    // ========================================================================

    testWidgets(
      'Register form detects password mismatch',
      (WidgetTester tester) async {
        await tester.pumpWidget(const PrepLoopApp());
        await tester.pumpAndSettle();

        // --------------------------------------------------------------------
        // Open register page.
        // --------------------------------------------------------------------

        final Finder registerButton = find.widgetWithText(
          TextButton,
          'Register',
        );

        expect(
          registerButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          registerButton,
        );

        await tester.tap(
          registerButton,
        );

        await tester.pumpAndSettle();

        // --------------------------------------------------------------------
        // Make sure all four fields exist BEFORE using .at().
        // --------------------------------------------------------------------

        final Finder fields = find.byType(TextFormField);

        expect(
          fields,
          findsNWidgets(4),
        );

        // --------------------------------------------------------------------
        // FIELD 0 = Full Name
        // FIELD 1 = Email
        // FIELD 2 = Password
        // FIELD 3 = Confirm Password
        // --------------------------------------------------------------------

        await tester.enterText(
          fields.at(0),
          'Test User',
        );

        await tester.enterText(
          fields.at(1),
          'test@example.com',
        );

        await tester.enterText(
          fields.at(2),
          'password123',
        );

        await tester.enterText(
          fields.at(3),
          'different123',
        );

        await tester.pump();

        // --------------------------------------------------------------------
        // Find Create Account button.
        // --------------------------------------------------------------------

        final Finder createAccountButton = find.widgetWithText(
          ElevatedButton,
          'Create Account',
        );

        expect(
          createAccountButton,
          findsOneWidget,
        );

        await _makeVisible(
          tester,
          createAccountButton,
        );

        await tester.tap(
          createAccountButton,
        );

        await tester.pump();

        // --------------------------------------------------------------------
        // Password mismatch must be displayed.
        // --------------------------------------------------------------------

        expect(
          find.text('Passwords do not match'),
          findsOneWidget,
        );
      },
    );
  });
}

// ============================================================================
// SAFE SCROLL HELPER
// ============================================================================
//
// This uses Flutter's own ensureVisible() instead of manually selecting
// a SingleChildScrollView.
//
// That is important because the app can contain more than one scrollable
// widget on mobile/test layouts.
//
// ============================================================================

Future<void> _makeVisible(
  WidgetTester tester,
  Finder finder,
) async {
  if (finder.evaluate().isEmpty) {
    return;
  }

  try {
    await tester.ensureVisible(
      finder.first,
    );

    await tester.pumpAndSettle();
  } catch (_) {
    // If the widget is already visible, there is nothing else to do.
  }
}