import 'otp_page.dart';
import 'package:flutter/material.dart';
import '../../core/supabase_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _hidePassword = true;

  static const Color navy = Color(0xFF202B55);
  static const Color purple = Color(0xFF7167E8);
  static const Color background = Color(0xFFF6F7FB);
  static const Color muted = Color(0xFF858BA3);
  static const Color border = Color(0xFFEAECF3);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: navy,
      ),
    );
  }

Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isLogin) {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      _showMessage('Login successful!');
    } else {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': _nameController.text.trim(),
        },
      );

      if (!mounted) return;

      if (response.session == null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(email: email),
          ),
        );
      } else {
        _showMessage('Account created successfully!');
      }
    }
  } catch (error) {
    if (!mounted) return;

    _showMessage(
      error.toString().replaceFirst('Exception: ', ''),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _hidePassword = true;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 850;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildWelcomePanel(),
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 32,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 440,
                          ),
                          child: _buildForm(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      _buildMobileBrand(),
                      const SizedBox(height: 28),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomePanel() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 48,
        vertical: 44,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF202B55),
            Color(0xFF303C78),
            Color(0xFF6258C9),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLogo(size: 48),
              const SizedBox(width: 14),
              const Text(
                'PrepLoop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFC5C0FF),
            size: 38,
          ),
          const SizedBox(height: 24),
          const Text(
            'Your next opportunity\nstarts here.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              height: 1.25,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Build your skills, sharpen your interview '
            'techniques, and prepare for the career you want.',
            style: TextStyle(
              color: Color(0xFFD9DDF1),
              fontSize: 16,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 34),
          _buildFeature(
            Icons.code_rounded,
            'Practice coding problems',
          ),
          const SizedBox(height: 18),
          _buildFeature(
            Icons.description_outlined,
            'Improve your resume',
          ),
          const SizedBox(height: 18),
          _buildFeature(
            Icons.record_voice_over_outlined,
            'Prepare for interviews',
          ),
          const Spacer(),
          const Text(
            'LEARN  •  PRACTICE  •  GROW',
            style: TextStyle(
              color: Color(0xFFCFCCFF),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBrand() {
    return Column(
      children: [
        _buildLogo(size: 58),
        const SizedBox(height: 14),
        const Text(
          'PrepLoop',
          style: TextStyle(
            color: navy,
            fontSize: 29,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your career preparation companion',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLogo({required double size}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.school_rounded,
        color: Colors.white,
        size: size * 0.56,
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.045),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isLogin ? 'Welcome back!' : 'Create your account',
              style: const TextStyle(
                color: navy,
                fontSize: 27,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              _isLogin
                  ? 'Sign in to continue your preparation journey.'
                  : 'Enter your details to get started with PrepLoop.',
              style: const TextStyle(
                color: muted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            if (!_isLogin) ...[
              _buildLabel('Full name'),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                decoration: _inputDecoration(
                  'Enter your full name',
                  Icons.person_outline_rounded,
                ),
                validator: (value) {
                  if (!_isLogin &&
                      (value == null || value.trim().isEmpty)) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],

            _buildLabel('Email address'),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: _inputDecoration(
                'you@example.com',
                Icons.mail_outline_rounded,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }

                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(value.trim())) {
                  return 'Enter a valid email address';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildLabel('Password'),
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              autofillHints: _isLogin
                  ? const [AutofillHints.password]
                  : const [AutofillHints.newPassword],
              decoration: _inputDecoration(
                'Enter your password',
                Icons.lock_outline_rounded,
              ).copyWith(
                suffixIcon: IconButton(
                  tooltip: _hidePassword
                      ? 'Show password'
                      : 'Hide password',
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: muted,
                    size: 21,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                if (!_isLogin && value.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),
            const SizedBox(height: 28),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  disabledBackgroundColor: purple.withValues(alpha: 0.55),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? 'Sign In' : 'Create Account',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 19,
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 22),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _isLogin
                        ? "Don't have an account?"
                        : 'Already have an account?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _isLoading ? null : _toggleMode,
                  child: Text(
                    _isLogin ? 'Register' : 'Sign In',
                    style: const TextStyle(
                      color: purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: border),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 16,
                  color: muted,
                ),
                SizedBox(width: 7),
                Flexible(
                  child: Text(
                    'Your journey to success starts here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        label,
        style: const TextStyle(
          color: navy,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFA5AABC),
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: muted, size: 21),
      filled: true,
      fillColor: const Color(0xFFF9FAFD),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: purple,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }
}
