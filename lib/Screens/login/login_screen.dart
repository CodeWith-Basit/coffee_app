import 'package:coffee_appv2/Screens/login/signup_screen.dart';
import 'package:coffee_appv2/core/services/auth_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/widget/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(color: Colors.white),
        ),
        backgroundColor: AppColors.burntCaramel,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await AuthService.instance.signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      } on FirebaseAuthException catch (e) {
        String msg = "Login failed. Please check your credentials.";
        if (e.code == 'user-not-found') {
          msg = "No user found with this email.";
        } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          msg = "Incorrect password or email. Please try again.";
        } else if (e.code == 'invalid-email') {
          msg = "Invalid email format.";
        } else if (e.code == 'user-disabled') {
          msg = "This account has been disabled.";
        }
        _showError(msg);
      } catch (e) {
        _showError("An unexpected error occurred. Please try again.");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _onGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final userCred = await AuthService.instance.signInWithGoogle();
      if (userCred != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Google Sign-In failed.");
    } catch (e) {
      _showError("Google Sign-In failed or was cancelled.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteMist,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Top Brand Badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deepEspresso,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "K Ō V É R A",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                        color: AppColors.warmPorcelain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Welcome Headline
                Text(
                  "Welcome Back,",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: AppColors.deepEspresso,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sip the finest craft blends tailored to your palate. Sign in to access your rewards & orders.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.mutedTaupe,
                  ),
                ),

                const SizedBox(height: 32),

                // Email Input Field
                _buildLabel("EMAIL ADDRESS"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deepEspresso,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: "your.name@example.com",
                    prefixIcon: Icons.mail_outline_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Input Field
                _buildLabel("PASSWORD"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deepEspresso,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: "••••••••",
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.mutedTaupe,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.burntCaramel,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? true;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Remember me",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.deepEspresso,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                     TextButton(
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        if (email.isEmpty) {
                          _showError("Please enter your email to reset password.");
                          return;
                        }
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          await AuthService.instance.sendPasswordResetEmail(email);
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Password reset link sent to your email.",
                              ),
                              backgroundColor: AppColors.burntCaramel,
                            ),
                          );
                        } catch (e) {
                          _showError("Could not send reset email. Verify your address.");
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.burntCaramel,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.burntCaramel,
                      disabledBackgroundColor:
                          AppColors.burntCaramel.withValues(alpha: 0.6),
                      foregroundColor: AppColors.warmPorcelain,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: AppColors.warmPorcelain,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sign In",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider: Or Continue With
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.mutedTaupe.withValues(alpha: 0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        "or continue with",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedTaupe,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.mutedTaupe.withValues(alpha: 0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Social Sign-in Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(
                        label: "Google",
                        icon: Icons.g_mobiledata_rounded,
                        iconColor: Colors.redAccent,
                        onTap: _isLoading ? () {} : _onGoogleLogin,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildSocialButton(
                        label: "Apple",
                        icon: Icons.apple,
                        iconColor: AppColors.deepEspresso,
                        onTap: () {
                          _showError("Apple Sign-In is configured for iOS devices.");
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // Switch to Sign Up
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.mutedTaupe,
                        ),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Sign Up",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.burntCaramel,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.deepEspresso,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppColors.mutedTaupe.withValues(alpha: 0.7),
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: AppColors.burntCaramel,
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.burntCaramel, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.8),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.deepEspresso,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
