import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../../core/constants/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../services/auth_service.dart';
import '../../router/app_router.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showForgotPasswordSheet() async {
    final emailController =
        TextEditingController(text: _emailController.text.trim());

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.pinkLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (sheetContext) {
        bool sending = false;
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) => Padding(
            padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reset password', style: AppTypography.h2),
                const SizedBox(height: 8),
                Text(
                  "Enter your email and we'll send you a reset link.",
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.gray500),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: PhosphorIcons.envelope(),
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: 'Send reset link',
                  isLoading: sending,
                  onPressed: () async {
                    final email = emailController.text.trim();
                    if (Validators.email(email) != null) return;
                    setSheetState(() => sending = true);
                    try {
                      await ref
                          .read(authServiceProvider)
                          .sendPasswordResetEmail(email);
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Reset link sent — check your inbox.',
                            ),
                          ),
                        );
                      }
                    } catch (_) {
                      setSheetState(() => sending = false);
                      if (sheetContext.mounted) {
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                          const SnackBar(
                            content: Text('Could not send reset email.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in with Google';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in with Apple';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(PhosphorIcons.arrowLeft()),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: AppTypography.h1,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your fitness journey',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.gray400,
                  ),
                ),
                const SizedBox(height: 32),
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.warningCircle(),
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Email field
                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: PhosphorIcons.envelope(),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                // Password field
                AppTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: PhosphorIcons.lock(),
                  validator: Validators.password,
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 8),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordSheet,
                    child: Text(
                      'Forgot password?',
                      style: AppTypography.buttonSmall.copyWith(
                        color: AppColors.pinkDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Login button
                AppButton(
                  label: 'Log In',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.gray200)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or continue with',
                        style: AppTypography.captionSmall,
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.gray200)),
                  ],
                ),
                const SizedBox(height: 24),
                // Social login buttons
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        label: 'Google',
                        icon: PhosphorIcons.googleLogo(),
                        onPressed: _loginWithGoogle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SocialButton(
                        label: 'Apple',
                        icon: PhosphorIcons.appleLogo(),
                        onPressed: _loginWithApple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signup),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign up',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.pinkDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.gray200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.gray900),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.buttonSmall.copyWith(
              color: AppColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
