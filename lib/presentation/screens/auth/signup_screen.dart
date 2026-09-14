import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../services/auth_service.dart';
import '../../router/app_router.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _agreedToTerms = false;
  String? _confirmationSentTo;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(() {
        _errorMessage = 'Please agree to the Terms & Privacy Policy';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );
      if (!mounted) return;
      if (response.session != null) {
        context.go(AppRoutes.onboarding);
      } else {
        // Email confirmation required — no session until the link is clicked
        setState(() {
          _confirmationSentTo = _emailController.text.trim();
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create account. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _signupWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign up with Google';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signupWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign up with Apple';
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
    if (_confirmationSentTo != null) {
      return _ConfirmEmailView(
        email: _confirmationSentTo!,
        onGoToLogin: () => context.go(AppRoutes.login),
      );
    }

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
                Text('Create Account', style: AppTypography.h1),
                const SizedBox(height: 8),
                Text(
                  'Start your 3-day free trial today',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
                ),
                const SizedBox(height: 32),
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(PhosphorIcons.warningCircle(), color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_errorMessage!, style: AppTypography.bodySmall.copyWith(color: AppColors.error))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter your name',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  prefixIcon: PhosphorIcons.user(),
                  validator: Validators.name,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: PhosphorIcons.envelope(),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  hint: 'Create a password (min 8 characters)',
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: PhosphorIcons.lock(),
                  validator: Validators.password,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.gray600),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.pinkDark, fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _openUrl(AppUrls.termsOfUse),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.pinkDark, fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _openUrl(AppUrls.privacyPolicy),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Start Free Trial', variant: AppButtonVariant.glow, onPressed: _signup, isLoading: _isLoading),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.gray200)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('or continue with', style: AppTypography.captionSmall)),
                    const Expanded(child: Divider(color: AppColors.gray200)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _SocialButton(label: 'Google', icon: PhosphorIcons.googleLogo(), onPressed: _signupWithGoogle)),
                    const SizedBox(width: 12),
                    Expanded(child: _SocialButton(label: 'Apple', icon: PhosphorIcons.appleLogo(), onPressed: _signupWithApple)),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600)),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.login),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text('Log in', style: AppTypography.bodyMedium.copyWith(color: AppColors.pinkDark, fontWeight: FontWeight.w600)),
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

class _ConfirmEmailView extends StatelessWidget {
  final String email;
  final VoidCallback onGoToLogin;

  const _ConfirmEmailView({required this.email, required this.onGoToLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(PhosphorIcons.envelopeOpen(), size: 64, color: AppColors.pinkDark),
              const SizedBox(height: 24),
              Text('Check your inbox', style: AppTypography.h1, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'We sent a confirmation link to\n$email\n\nConfirm your email, then log in to get started.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Go to Log In',
                variant: AppButtonVariant.glow,
                onPressed: onGoToLogin,
              ),
            ],
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

  const _SocialButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.gray200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.gray900),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.buttonSmall.copyWith(color: AppColors.gray900)),
        ],
      ),
    );
  }
}
