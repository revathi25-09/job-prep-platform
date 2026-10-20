
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

  static const Color primary = Color(0xFF3157D5);

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
          _showMessage(
            'Account created. Check your email to verify your account.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 2,
                shadowColor: Colors.black12,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: primary,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'PrepLoop',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF182443),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLogin
                              ? 'Welcome back! Sign in to continue.'
                              : 'Create your account and start preparing.',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 28),

                        if (!_isLogin) ...[
                          _buildLabel('Full name'),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization:
                                TextCapitalization.words,
                            decoration: _inputDecoration(
                              'Enter your full name',
                              Icons.person_outline,
                            ),
                            validator: (value) {
                              if (!_isLogin &&
                                  (value == null ||
                                      value.trim().isEmpty)) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                        ],

                        _buildLabel('Email address'),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.email,
                          ],
                          decoration: _inputDecoration(
                            'you@example.com',
                            Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
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
                        const SizedBox(height: 18),

                        _buildLabel('Password'),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          autofillHints: _isLogin
                              ? const [AutofillHints.password]
                              : const [
                                  AutofillHints.newPassword,
                                ],
                          decoration: _inputDecoration(
                            'Enter your password',
                            Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
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
                        const SizedBox(height: 26),

                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isLogin
                                        ? 'Sign In'
                                        : 'Create Account',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                _isLogin
                                    ? "Don't have an account? "
                                    : 'Already have an account? ',
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                        _formKey.currentState?.reset();
                                      });
                                    },
                              child: Text(
                                _isLogin ? 'Register' : 'Sign In',
                                style: const TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your preparation journey starts here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF263451),
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
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E5EF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E5EF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    );
  }
}
