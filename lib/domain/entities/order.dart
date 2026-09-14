/// Shipping address for orders
class ShippingAddress {
  final String name;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const ShippingAddress({
    required this.name,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
      };

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      name: json['name'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
    );
  }
}

/// Order status
enum OrderStatus {
  pending,
  paid,
  failed,
  refunded,
}

/// Order entity
class Order {
  final String id;
  final String userId;
  final String? stripePaymentIntentId;
  final OrderStatus status;
  final int subtotal;
  final int totalAmount;
  final String currency;
  final ShippingAddress? shippingAddress;
  final DateTime? paidAt;
  final DateTime createdAt;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.userId,
    this.stripePaymentIntentId,
    required this.status,
    required this.subtotal,
    required this.totalAmount,
    required this.currency,
    this.shippingAddress,
    this.paidAt,
    required this.createdAt,
    this.items = const [],
  });

  double get subtotalInMajorUnits => subtotal / 100;
  double get totalInMajorUnits => totalAmount / 100;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      subtotal: json['subtotal'] as int,
      totalAmount: json['total_amount'] as int,
      currency: json['currency'] as String? ?? 'eur',
      shippingAddress: json['shipping_address'] != null
          ? ShippingAddress.fromJson(json['shipping_address'])
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: (json['order_items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

/// Order item
class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final int productPrice;
  final int quantity;
  final int subtotal;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.subtotal,
  });

  double get priceInMajorUnits => productPrice / 100;
  double get subtotalInMajorUnits => subtotal / 100;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productPrice: json['product_price'] as int,
      quantity: json['quantity'] as int,
      subtotal: json['subtotal'] as int,
    );
  }
}
