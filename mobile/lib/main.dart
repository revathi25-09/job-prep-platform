import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://owfwxrjeiiqshjefacjg.supabase.co',
    publishableKey: 'sb_publishable_WL7gLW-XH920Z1HPOm0ndQ_d2ChyFOV',
  );

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
                child:  LeftMarketingPanel(),
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
            constraints: const BoxConstraints(minHeight: 650),
            child:  LeftMarketingPanel(),
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
// CONTINUE LEFT MARKETING PANEL
// ============================================================================

class LeftMarketingPanel extends StatelessWidget {
  const LeftMarketingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 650),
      padding: const EdgeInsets.symmetric(
        horizontal: 48,
        vertical: 45,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEEF2FF),
            Color(0xFFF5F3FF),
            Color(0xFFE0E7FF),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'PrepLoop',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 65),
          const Text(
            'Your next opportunity\nstarts here.',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 38,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Prepare smarter, practice consistently, '
            'and build the skills you need to succeed '
            'in your placement journey.',
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 15,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 42),
          const FeatureItem(
            icon: Icons.code_rounded,
            title: 'Practice coding',
            description:
                'Improve your problem-solving skills with regular practice.',
          ),
          const SizedBox(height: 25),
          const FeatureItem(
            icon: Icons.track_changes_rounded,
            title: 'Track your progress',
            description:
                'Monitor your preparation and identify areas to improve.',
          ),
          const SizedBox(height: 25),
          const FeatureItem(
            icon: Icons.work_outline_rounded,
            title: 'Get placement-ready',
            description:
                'Build confidence for technical interviews and career opportunities.',
          ),
          const Spacer(),
          const Text(
            'Learn. Practice. Grow.',
            style: TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

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

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _loading = false;

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
      final email = _emailController.text.trim();

      final response =
          await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      if (response.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardPage(
              userEmail: email,
            ),
          ),
        );
      }
    } on AuthException catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(error.message);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage('Login failed. Please try again.');
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
          duration: const Duration(seconds: 4),
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
                "Don't have an account?",
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 13,
                ),
              ),
              TextButton(
                onPressed: widget.onRegister,
                child: const Text(
                  'Register',
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
        const Text(
          'Welcome Back',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue your PrepLoop journey.',
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
              const AuthLabel(text: 'Email Address'),
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
              const AuthLabel(text: 'Password'),
              const SizedBox(height: 8),
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
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: const Color(0xFF4F46E5),
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
                      color: Color(0xFF475467),
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      _showMessage(
                        'Please use the password reset option '
                        'configured for your account.',
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                text: 'Login',
                loading: _loading,
                onPressed: _login,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'By continuing, you agree to our Terms of Service '
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
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();

    if (_nameController.text.trim().isEmpty) {
      _showMessage('Please enter your full name.');
      return;
    }

    final email = _emailController.text.trim();

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    setState(() => _loading = true);

    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
        data: {
          'name': _nameController.text.trim(),
        },
      );

      if (!mounted) return;

      setState(() {
        _otpSent = true;
        _otpVerified = false;
        _loading = false;
      });

      _showMessage('Verification code sent to $email');
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage('Could not send OTP. Please try again.');
    }
  }

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();

    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showMessage('Please enter the OTP sent to your email.');
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await _supabase.auth.verifyOTP(
        email: _emailController.text.trim(),
        token: otp,
        type: OtpType.email,
      );

      if (!mounted) return;

      if (response.user == null || response.session == null) {
        setState(() => _loading = false);
        _showMessage('OTP verification failed. Please try again.');
        return;
      }

      setState(() {
        _otpVerified = true;
        _loading = false;
      });

      _showMessage('Email verified successfully!');
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage('Invalid OTP. Please try again.');
    }
  }

  Future<void> _resendOtp() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      await _supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        shouldCreateUser: true,
        data: {
          'name': _nameController.text.trim(),
        },
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
        _otpController.clear();
      });

      _showMessage('A new OTP has been sent to your email.');
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage('Could not resend OTP. Please try again.');
    }
  }

  Future<void> _completeRegistration() async {
    FocusScope.of(context).unfocus();

    if (!_otpVerified) {
      _showMessage('Please verify your email first.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // The OTP verification step has already authenticated the user.
      // Set the password and save the user's name in their metadata.
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          password: password,
          data: {'name': name},
        ),
      );

      if (!mounted) return;

      if (response.user == null) {
        setState(() => _loading = false);
        _showMessage('Could not complete registration.');
        return;
      }

      setState(() => _loading = false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            userEmail: email,
          ),
        ),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage('Registration failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
          const SizedBox(height: 24),
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
            'Join PrepLoop and start your preparation journey.',
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 14.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),

          // Full name
          const AuthLabel(text: 'Full Name'),
          const SizedBox(height: 8),
          AuthTextField(
            controller: _nameController,
            hintText: 'Enter your full name',
            icon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Email address
          const AuthLabel(text: 'Email Address'),
          const SizedBox(height: 8),
          AuthTextField(
            controller: _emailController,
            hintText: 'Enter your email',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            enabled: !_otpSent,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                  .hasMatch(value.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Step 1: Send OTP
          if (!_otpSent)
            PrimaryButton(
              text: 'Send Verification OTP',
              loading: _loading,
              onPressed: _sendOtp,
            ),

          // Step 2: Verify OTP
          if (_otpSent && !_otpVerified) ...[
            const AuthLabel(text: 'Email Verification OTP'),
            const SizedBox(height: 8),
            AuthTextField(
              controller: _otpController,
              hintText: 'Enter the OTP from your email',
              icon: Icons.mark_email_read_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'OTP is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Verify OTP',
              loading: _loading,
              onPressed: _verifyOtp,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loading ? null : _resendOtp,
              child: const Text(
                'Resend OTP',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          // Step 3: Create password after OTP verification
          if (_otpVerified) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF039855),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Email verified successfully',
                      style: TextStyle(
                        color: Color(0xFF027A48),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const AuthLabel(text: 'Create Password'),
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
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            const AuthLabel(text: 'Confirm Password'),
            const SizedBox(height: 8),
            AuthTextField(
              controller: _confirmPasswordController,
              hintText: 'Re-enter your password',
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

            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Create Account',
              loading: _loading,
              onPressed: _completeRegistration,
            ),
          ],

          const SizedBox(height: 24),
          const Text(
            'By continuing, you agree to our Terms of Service '
            'and Privacy Policy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF98A2B3),
              fontSize: 11.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

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
        color: Color(0xFF344054),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool enabled;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF667085),
          size: 21,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
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
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

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
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF9CA3AF),
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
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
