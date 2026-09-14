/// Subscription plan entity
class SubscriptionPlan {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String currency;
  final String interval; // 'month', 'year', 'lifetime'
  final int intervalCount;
  final List<String> features;
  final bool isPopular;
  final bool isActive;
  final String? stripePriceId;
  final String? appleProductId;
  final String? googleProductId;
  final int sortOrder;
  final DateTime? createdAt;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.currency = 'EUR',
    this.interval = 'month',
    this.intervalCount = 1,
    this.features = const [],
    this.isPopular = false,
    this.isActive = true,
    this.stripePriceId,
    this.appleProductId,
    this.googleProductId,
    this.sortOrder = 0,
    this.createdAt,
  });

  bool get isLifetime => interval == 'lifetime';
  bool get isMonthly => interval == 'month';
  bool get isYearly => interval == 'year';

  String get priceDisplay {
    final symbol = currency == 'EUR' ? '\u20AC' : '\$';
    if (isLifetime) return '$symbol${price.toStringAsFixed(0)}';
    return '$symbol${price.toStringAsFixed(0)}/${interval}';
  }

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      interval: json['interval'] as String? ?? 'month',
      intervalCount: json['interval_count'] as int? ?? 1,
      features: (json['features'] as List<dynamic>?)?.cast<String>() ?? [],
      isPopular: json['is_popular'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      stripePriceId: json['stripe_price_id'] as String?,
      appleProductId: json['apple_product_id'] as String?,
      googleProductId: json['google_product_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
