import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../services/auth_service.dart';

/// The logged-in user's profile row (null when logged out or missing).
final currentProfileProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  // Re-fetch whenever auth state changes (login, logout, user switch)
  ref.watch(authStateProvider);

  final user = SupabaseConfig.currentUser;
  if (user == null) return null;

  return await SupabaseConfig.client
      .from('profiles')
      .select()
      .eq('id', user.id)
      .maybeSingle();
});

/// First name for greetings, falling back to auth metadata.
final userFirstNameProvider = FutureProvider<String?>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final fullName = (profile?['full_name'] as String?) ??
      (SupabaseConfig.currentUser?.userMetadata?['full_name'] as String?);
  final first = fullName?.trim().split(RegExp(r'\s+')).first;
  return (first == null || first.isEmpty) ? null : first;
});
