import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('PrepLoop login page loads correctly', (
    WidgetTester tester,
  ) async {
    // Build the PrepLoop application.
    await tester.pumpWidget(const PrepLoopApp());

    // Verify the PrepLoop branding is displayed.
    expect(find.text('PrepLoop'), findsOneWidget);

    // Verify the main marketing content.
    expect(find.text('Build Skills.'), findsOneWidget);
    expect(find.text('Ace Interviews.'), findsOneWidget);
    expect(find.text('Launch Your Career.'), findsOneWidget);

    // Verify the login content.
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(
      find.text('Login to continue your learning journey'),
      findsOneWidget,
    );

    // Verify login fields.
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify login actions.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);

    // Verify social login options.
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);

    // Verify registration link.
    expect(find.text('New here?'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('Register page opens when Register is clicked', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PrepLoopApp());

    // Verify we start on the login page.
    expect(find.text('Welcome Back!'), findsOneWidget);

    // Click Register.
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Verify registration page is displayed.
    expect(find.text('Create Account'), findsOneWidget);
    expect(
      find.text(
        'Create your PrepLoop account and start your journey.',
      ),
      findsOneWidget,
    );

    // Verify registration fields.
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);

    // Verify registration button.
    expect(find.text('Create Account'), findsOneWidget);

    // Verify login link.
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Login page opens from Register page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PrepLoopApp());

    // Open Register page.
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);

    // Go back to Login.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify login page is displayed.
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login to continue your learning journey'), findsOneWidget);
  });
}