import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';
import '../core/utils/logger.dart';

/// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseConfig.authStateChanges;
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return SupabaseConfig.currentUser;
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Authentication service
class AuthService {
  final _client = SupabaseConfig.client;

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      // With email confirmation enabled there is no session yet and RLS
      // would reject the insert; the profile is then created after the
      // first login (onboarding upserts it).
      if (response.user != null && response.session != null) {
        await _createProfile(response.user!, fullName);
      }

      return response;
    } catch (e) {
      AppLogger.error('Sign up error', e);
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      AppLogger.error('Sign in error', e);
      rethrow;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      final success = await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.lagym.app://login-callback',
      );
      return success;
    } catch (e) {
      AppLogger.error('Google sign in error', e);
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    try {
      final success = await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'com.lagym.app://login-callback',
      );
      return success;
    } catch (e) {
      AppLogger.error('Apple sign in error', e);
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      AppLogger.error('Password reset error', e);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      AppLogger.error('Sign out error', e);
      rethrow;
    }
  }

  /// Create user profile. The 3-day free trial is granted by the store
  /// (App Store / Play Store introductory offer) when the user starts a
  /// subscription; the RevenueCat webhook then updates subscription fields.
  /// Upsert so a retried signup or an existing row doesn't fail.
  Future<void> _createProfile(User user, String? fullName) async {
    await _client.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'full_name': fullName ?? user.userMetadata?['full_name'],
      'avatar_url': user.userMetadata?['avatar_url'],
      'subscription_tier': 'free',
      'subscription_status': 'inactive',
      'onboarding_completed': false,
    }, onConflict: 'id', ignoreDuplicates: true);
  }

  /// Get current session
  Session? get currentSession => _client.auth.currentSession;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;
}
