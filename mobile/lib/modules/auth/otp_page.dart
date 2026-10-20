import '../../main.dart';
import 'package:flutter/material.dart';
import '../../core/supabase_client.dart';
import 'package:gotrue/gotrue.dart';
class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({
    super.key,
    required this.email,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  static const Color navy = Color(0xFF202B55);
  static const Color purple = Color(0xFF7167E8);

  @override
  void dispose() {
    _otpController.dispose();
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

  Future<void> _verifyOtp() async {
    final token = _otpController.text.trim();

    if (token.isEmpty) {
      _showMessage('Please enter the OTP sent to your email.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await supabase.auth.verifyOTP(
        email: widget.email,
        token: token,
        type: OtpType.signup,
      );

      if (!mounted) return;

      _showMessage('Email verified successfully!');

      // Return to AuthGate. Its auth stream should now
      // display the dashboard for the verified user.
      // Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(
    builder: (_) => const AuthGate(),
  ),
  (route) => false,
);
    } catch (error) {
      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);

    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );

      _showMessage('A new verification email has been requested.');
    } catch (error) {
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
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        title: const Text('Email verification'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFEAECF3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_read_rounded,
                    color: purple,
                    size: 64,
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Verify your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: navy,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enter the verification code sent to:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 8,
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFF8F9FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFEAECF3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: purple,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isLoading ? null : _resendOtp,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: purple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
