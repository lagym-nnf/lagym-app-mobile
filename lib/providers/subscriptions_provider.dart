import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/subscription_plan.dart';

/// Provider for fetching all subscription plans
final subscriptionPlansProvider = FutureProvider<List<SubscriptionPlan>>((ref) async {
  final response = await SupabaseConfig.client
      .from('subscription_plans')
      .select()
      .eq('is_active', true)
      .order('sort_order');

  return (response as List).map((json) => SubscriptionPlan.fromJson(json)).toList();
});

/// Provider for fetching a single subscription plan by ID
final subscriptionPlanProvider = FutureProvider.family<SubscriptionPlan?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('subscription_plans')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return SubscriptionPlan.fromJson(response);
});

/// Provider for fetching the most popular plan
final popularPlanProvider = FutureProvider<SubscriptionPlan?>((ref) async {
  final response = await SupabaseConfig.client
      .from('subscription_plans')
      .select()
      .eq('is_active', true)
      .eq('is_popular', true)
      .limit(1)
      .maybeSingle();

  if (response == null) return null;
  return SubscriptionPlan.fromJson(response);
});

/// Provider for fetching user's current subscription
final userSubscriptionProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final userId = SupabaseConfig.currentUser?.id;
  if (userId == null) return null;

  final response = await SupabaseConfig.client
      .from('user_subscriptions')
      .select('*, subscription_plans(*)')
      .eq('user_id', userId)
      .eq('status', 'active')
      .maybeSingle();

  return response;
});
