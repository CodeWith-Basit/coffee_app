import 'package:coffee_appv2/core/services/auth_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/widget/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  void _onSignUp() async {
    if (!_agreeTerms) {
      _showError("Please accept the Terms & Privacy Policy");
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await AuthService.instance.signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created! Welcome to KŌVÉRA."),
            backgroundColor: AppColors.burntCaramel,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        String msg = "Registration failed. Please try again.";
        if (e.code == 'email-already-in-use') {
          msg = "An account already exists for this email.";
        } else if (e.code == 'weak-password') {
          msg = "Password is too weak. Must be at least 6 characters.";
        } else if (e.code == 'invalid-email') {
          msg = "Invalid email format.";
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.deepEspresso,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.deepEspresso,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "K Ō V É R A",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.warmPorcelain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Join the Ritual,",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: AppColors.deepEspresso,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create your bespoke account for exclusive roastery drops, customized brewing, and member rewards.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.mutedTaupe,
                  ),
                ),

                const SizedBox(height: 28),

                // Full Name
                _buildLabel("FULL NAME"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deepEspresso,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: "Alexander Wright",
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your full name";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Email Address
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
                    hintText: "alexander@luxurycoffee.com",
                    prefixIcon: Icons.mail_outline_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Password
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
                    hintText: "Minimum 6 characters",
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
                      return "Please enter a password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Confirm Password
                _buildLabel("CONFIRM PASSWORD"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deepEspresso,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: "Re-enter your password",
                    prefixIcon: Icons.lock_reset_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.mutedTaupe,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Agree Terms Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreeTerms,
                        activeColor: AppColors.burntCaramel,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _agreeTerms = val ?? true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "I agree to KŌVÉRA's Terms of Service and Privacy Policy.",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.espressoText,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSignUp,
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
                                "Create Account",
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

                const SizedBox(height: 20),

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
                        "or sign up with",
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

                const SizedBox(height: 18),

                // Social Sign-up Buttons
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

                const SizedBox(height: 24),

                // Already have an account? Sign In
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.mutedTaupe,
                        ),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Sign In",
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

                const SizedBox(height: 24),
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
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
