import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/coach.dart';

/// Provider for fetching team members from Supabase
final teamMembersProvider = FutureProvider<List<Coach>>((ref) async {
  final response = await SupabaseConfig.client
      .from('team_members')
      .select()
      .eq('is_active', true)
      .eq('is_featured', true)
      .order('sort_order', ascending: true);

  return (response as List).map((json) => _teamMemberToCoach(json)).toList();
});

/// Provider for fetching all team members (including non-featured)
final allTeamMembersProvider = FutureProvider<List<Coach>>((ref) async {
  final response = await SupabaseConfig.client
      .from('team_members')
      .select()
      .eq('is_active', true)
      .order('sort_order');

  return (response as List).map((json) => _teamMemberToCoach(json)).toList();
});

/// Provider for fetching a single team member by ID
final teamMemberProvider = FutureProvider.family<Coach?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('team_members')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return _teamMemberToCoach(response);
});

/// Provider for fetching team members by role
final teamMembersByRoleProvider = FutureProvider.family<List<Coach>, String>((ref, role) async {
  final response = await SupabaseConfig.client
      .from('team_members')
      .select()
      .eq('is_active', true)
      .eq('role', role)
      .order('sort_order');

  return (response as List).map((json) => _teamMemberToCoach(json)).toList();
});

/// Convert Supabase team_member JSON to Coach entity
Coach _teamMemberToCoach(Map<String, dynamic> json) {
  return Coach(
    id: json['id'] as String,
    name: json['name'] as String,
    title: json['title'] as String?,
    bio: json['bio'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    specialties: (json['specialties'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    rating: 4.9, // Could be calculated from reviews table in the future
    totalSessions: 0, // Could be fetched from sessions table
    isPrivateCoach: true,
    acceptsNewClients: json['is_active'] as bool? ?? true,
    role: json['role'] as String?,
    experienceYears: json['experience_years'] as int?,
    certifications: (json['certifications'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    socialInstagram: json['social_instagram'] as String?,
    socialLinkedin: json['social_linkedin'] as String?,
  );
}
