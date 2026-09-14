import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/service_provider.dart';

/// Service providers (nutritionists, physiotherapists) come from the
/// team_members table, which the admin manages on the Team page.
final serviceProvidersByRoleProvider =
    FutureProvider.family<List<ServiceProvider>, String>((ref, role) async {
  final response = await SupabaseConfig.client
      .from('team_members')
      .select()
      .eq('role', role)
      .eq('is_active', true)
      .order('sort_order');

  return (response as List)
      .map((json) => ServiceProvider.fromTeamMember(json))
      .toList();
});

/// A single service provider by team member id
final serviceProviderProvider =
    FutureProvider.family<ServiceProvider?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('team_members')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return ServiceProvider.fromTeamMember(response);
});
