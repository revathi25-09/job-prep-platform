import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PrepLoopApp());
}

// ============================================================================
// APP
// ============================================================================

class PrepLoopApp extends StatelessWidget {
  const PrepLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrepLoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

// ============================================================================
// AUTH PAGE
// ============================================================================

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  bool _showRegister = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changePage(bool register) {
    if (_showRegister == register) return;

    setState(() {
      _showRegister = register;
    });

    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 850;

          if (isMobile) {
            return _buildMobileLayout();
          }

          return Row(
            children: [
              const Expanded(
                flex: 11,
                child: LeftMarketingPanel(),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 55,
                        vertical: 40,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 470,
                        ),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _showRegister
                                ? RegisterForm(
                                    onLogin: () => _changePage(false),
                                  )
                                : LoginForm(
                                    onRegister: () => _changePage(true),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(
              minHeight: 650,
            ),
            child: const LeftMarketingPanel(),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 35,
            ),
            child: _showRegister
                ? RegisterForm(
                    onLogin: () => _changePage(false),
                  )
                : LoginForm(
                    onRegister: () => _changePage(true),
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LEFT MARKETING PANEL
// ============================================================================

class LeftMarketingPanel extends StatelessWidget {
  const LeftMarketingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF4F5FF),
            Color(0xFFE9E9FF),
            Color(0xFFDCDDFF),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: _GlowCircle(
              size: 280,
              color: const Color(0xFFB9B6FF),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: _GlowCircle(
              size: 300,
              color: const Color(0xFFAAA7FF),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 35,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F46E5)
                                  .withValues(alpha: 0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.all_inclusive_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'PrepLoop',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF27316B),
                          letterSpacing: -0.7,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  const Text(
                    'Build Skills.',
                    style: TextStyle(
                      fontSize: 42,
                      height: 1.08,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      letterSpacing: -1.5,
                    ),
                  ),
                  const Text(
                    'Ace Interviews.',
                    style: TextStyle(
                      fontSize: 42,
                      height: 1.08,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      letterSpacing: -1.5,
                    ),
                  ),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Launch Your ',
                          style: TextStyle(
                            fontSize: 42,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                            letterSpacing: -1.5,
                          ),
                        ),
                        TextSpan(
                          text: 'Career.',
                          style: TextStyle(
                            fontSize: 42,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4F46E5),
                            letterSpacing: -1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'PrepLoop is your all-in-one platform to prepare, '
                    'practice and get placed in your dream job.',
                    style: TextStyle(
                      color: Color(0xFF596174),
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const FeatureItem(
                    icon: Icons.menu_book_rounded,
                    title: 'Expert Learning',
                    description:
                        'Learn from industry experts and master in-demand skills.',
                  ),
                  const SizedBox(height: 18),
                  const FeatureItem(
                    icon: Icons.track_changes_rounded,
                    title: 'Practice & Improve',
                    description:
                        'Solve real interview questions and improve with instant feedback.',
                  ),
                  const SizedBox(height: 18),
                  const FeatureItem(
                    icon: Icons.work_outline_rounded,
                    title: 'Get Placed',
                    description:
                        'Apply to top companies and kickstart your career.',
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: _FallbackIllustration(),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.people_alt_outlined,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '50K+',
                              style: TextStyle(
                                color: Color(0xFF2836A3),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Students Trust PrepLoop',
                              style: TextStyle(
                                color: Color(0xFF687083),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FEATURE ITEM
// ============================================================================

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xFF5B5BF7),
            size: 25,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOGIN FORM
// ============================================================================

class LoginForm extends StatefulWidget {
  final VoidCallback onRegister;

  const LoginForm({
    super.key,
    required this.onRegister,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _loading = false;

  // --------------------------------------------------------------------------
  // BACKEND URL
  //
  // For Flutter Web/Desktop:
  // localhost normally works when your backend is running on this computer.
  //
  // For Android Emulator:
  // use 10.0.2.2 instead of localhost.
  // --------------------------------------------------------------------------

  static const String _loginUrl = 'http://localhost:5000/login';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final http.Response response = await http
          .post(
            Uri.parse(_loginUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      final Map<String, dynamic> data = _decodeResponse(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _showMessage(
          data['message']?.toString() ?? 'Login successful!',
        );
        return;
      }

      // IMPORTANT:
      // Show the actual backend response instead of hiding it
      // behind only "Login failed".
      final String message = data['message']?.toString().isNotEmpty == true
          ? data['message'].toString()
          : response.body.isNotEmpty
              ? response.body
              : 'Server returned status ${response.statusCode}.';

      _showMessage(
        'Login failed (${response.statusCode}): $message',
      );
    } on http.ClientException catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Could not connect to server.\n$error',
      );
    } on FormatException {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Server returned an invalid response.',
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Login error: $error',
      );
    }
  }

  Map<String, dynamic> _decodeResponse(String body) {
    if (body.trim().isEmpty) {
      return {};
    }

    try {
      final dynamic decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {};
    } catch (_) {
      return {};
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'New here?',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 7),
              TextButton(
                onPressed: widget.onRegister,
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 35),
        const Text(
          'Welcome Back!',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Login to continue your learning journey',
          style: TextStyle(
            color: Color(0xFF667085),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 42),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthLabel(
                text: 'Email Address',
              ),
              const SizedBox(height: 9),
              AuthTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }

                  if (!RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuthLabel(
                    text: 'Password',
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              AuthTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF667085),
                    size: 21,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }

                  if (value.length < 6) {
                    return 'Minimum 6 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              PrimaryButton(
                text: 'Login',
                loading: _loading,
                onPressed: _login,
              ),
            ],
          ),
        ),
        const SizedBox(height: 38),
        const OrDivider(),
        const SizedBox(height: 25),
        SocialLoginButton(
          icon: 'G',
          iconColor: const Color(0xFF4285F4),
          text: 'Continue with Google',
          onPressed: () {},
        ),
        const SizedBox(height: 14),
        SocialLoginButton(
          icon: 'A',
          iconColor: Colors.black,
          text: 'Continue with Apple',
          onPressed: () {},
        ),
        const SizedBox(height: 35),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 17,
              color: Color(0xFF98A2B3),
            ),
            SizedBox(width: 8),
            Text(
              'Your data is secure with us.',
              style: TextStyle(
                color: Color(0xFF98A2B3),
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// REGISTER FORM
// ============================================================================

class RegisterForm extends StatefulWidget {
  final VoidCallback onLogin;

  const RegisterForm({
    super.key,
    required this.onLogin,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  static const String _registerUrl = 'http://localhost:5000/register';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final http.Response response = await http
          .post(
            Uri.parse(_registerUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      final Map<String, dynamic> data = _decodeResponse(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        _showMessage(
          data['message']?.toString() ?? 'Registration successful!',
        );

        Future.delayed(
          const Duration(milliseconds: 800),
          () {
            if (mounted) {
              widget.onLogin();
            }
          },
        );

        return;
      }

      final String message =
          data['message']?.toString().isNotEmpty == true
              ? data['message'].toString()
              : response.body.isNotEmpty
                  ? response.body
                  : 'Server returned status ${response.statusCode}.';

      _showMessage(
        'Registration failed (${response.statusCode}): $message',
      );
    } on http.ClientException catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Could not connect to server.\n$error',
      );
    } on FormatException {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Server returned an invalid response.',
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Registration error: $error',
      );
    }
  }

  Map<String, dynamic> _decodeResponse(String body) {
    if (body.trim().isEmpty) {
      return {};
    }

    try {
      final dynamic decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {};
    } catch (_) {
      return {};
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 13,
                ),
              ),
              TextButton(
                onPressed: widget.onLogin,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Kept exactly as expected by your current tests.
        const Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 8),
        const Text(
          'Create your PrepLoop account and start your journey.',
          style: TextStyle(
            color: Color(0xFF667085),
            fontSize: 14.5,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthLabel(
                text: 'Full Name',
              ),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _nameController,
                hintText: 'Enter your full name',
                icon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }

                  if (value.trim().length < 2) {
                    return 'Enter a valid name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              const AuthLabel(
                text: 'Email Address',
              ),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }

                  if (!RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              const AuthLabel(
                text: 'Password',
              ),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _passwordController,
                hintText: 'Create a password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF667085),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }

                  if (value.length < 6) {
                    return 'Minimum 6 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              const AuthLabel(
                text: 'Confirm Password',
              ),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm your password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF667085),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }

                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 28),

              // IMPORTANT:
              // The button remains "Create Account" because that is what
              // your current widget_test.dart expects.
              PrimaryButton(
                text: 'Create Account',
                loading: _loading,
                onPressed: _register,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'By creating an account, you agree to our Terms of Service '
          'and Privacy Policy.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 11.5,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 30),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 17,
              color: Color(0xFF98A2B3),
            ),
            SizedBox(width: 8),
            Text(
              'Your data is secure with us.',
              style: TextStyle(
                color: Color(0xFF98A2B3),
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// AUTH LABEL
// ============================================================================

class AuthLabel extends StatelessWidget {
  final String text;

  const AuthLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF1D2939),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ============================================================================
// TEXT FIELD
// ============================================================================

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        color: Color(0xFF101828),
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: const Color(0xFF4F46E5),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF98A2B3),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF667085),
          size: 21,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD0D5DD),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD0D5DD),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF4F46E5),
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          fontSize: 11,
        ),
      ),
    );
  }
}

// ============================================================================
// PRIMARY BUTTON
// ============================================================================

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF818CF8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

// ============================================================================
// OR DIVIDER
// ============================================================================

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFE4E7EC),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 13,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFE4E7EC),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SOCIAL BUTTON
// ============================================================================

class SocialLoginButton extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String text;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFFD0D5DD),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(
                color: iconColor,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 11),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1D2939),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// GLOW CIRCLE
// ============================================================================

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.30),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FALLBACK ILLUSTRATION
// ============================================================================

class _FallbackIllustration extends StatelessWidget {
  const _FallbackIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: 25,
            child: Container(
              width: 155,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(65),
              ),
            ),
          ),
          const Positioned(
            top: 45,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFFFD7B5),
            ),
          ),
          Positioned(
            top: 30,
            child: Container(
              width: 88,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF263238),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Column(
              children: [
                Container(
                  width: 135,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF263238),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.all_inclusive_rounded,
                      color: Color(0xFF818CF8),
                      size: 42,
                    ),
                  ),
                ),
                Container(
                  width: 165,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(0xFF455A64),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 20,
            left: 25,
            child: Icon(
              Icons.menu_book_rounded,
              color: Color(0xFF4F46E5),
              size: 38,
            ),
          ),
          const Positioned(
            top: 65,
            right: 20,
            child: Icon(
              Icons.track_changes_rounded,
              color: Color(0xFF5B5BF7),
              size: 42,
            ),
          ),
          const Positioned(
            bottom: 65,
            right: 15,
            child: Icon(
              Icons.work_outline_rounded,
              color: Color(0xFF4F46E5),
              size: 38,
            ),
          ),
        ],
      ),
    );
  }
}