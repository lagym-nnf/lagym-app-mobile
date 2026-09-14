import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/quote.dart';

/// Provider for fetching all quotes
final quotesProvider = FutureProvider<List<Quote>>((ref) async {
  final response = await SupabaseConfig.client
      .from('quotes')
      .select()
      .eq('is_active', true)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Quote.fromJson(json)).toList();
});

/// Provider for fetching a single quote by ID
final quoteProvider = FutureProvider.family<Quote?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('quotes')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return Quote.fromJson(response);
});

/// Provider for fetching today's quote
final todaysQuoteProvider = FutureProvider<Quote?>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  // First try to get scheduled quote for today
  final scheduledResponse = await SupabaseConfig.client
      .from('quotes')
      .select()
      .eq('scheduled_date', today)
      .eq('is_active', true)
      .maybeSingle();

  if (scheduledResponse != null) {
    return Quote.fromJson(scheduledResponse);
  }

  // Fallback to random active quote based on day of year
  final allQuotes = await SupabaseConfig.client
      .from('quotes')
      .select()
      .eq('is_active', true)
      .order('created_at');

  final quotes = (allQuotes as List).map((json) => Quote.fromJson(json)).toList();
  if (quotes.isEmpty) return null;

  // Use day of year as seed for consistent daily quote
  final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
  return quotes[dayOfYear % quotes.length];
});

/// Provider for fetching quotes by category
final quotesByCategoryProvider = FutureProvider.family<List<Quote>, String>((ref, category) async {
  final response = await SupabaseConfig.client
      .from('quotes')
      .select()
      .eq('is_active', true)
      .eq('category', category)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Quote.fromJson(json)).toList();
});
