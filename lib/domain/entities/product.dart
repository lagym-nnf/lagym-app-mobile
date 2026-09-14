/// Product category
enum ProductCategory {
  equipment,
  apparel,
  accessories,
  supplements,
}

/// Product entity
class Product {
  final String id;
  final String name;
  final String description;
  final ProductCategory category;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.images = const [],
    this.sizes = const [],
    this.colors = const [],
    this.rating = 5.0,
    this.reviewCount = 0,
    this.inStock = true,
    this.isFeatured = false,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercent =>
      hasDiscount ? ((originalPrice! - price) / originalPrice! * 100).round().toDouble() : 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: ProductCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ProductCategory.equipment,
      ),
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      imageUrl: json['image_url'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      sizes: (json['sizes'] as List<dynamic>?)?.cast<String>() ?? [],
      colors: (json['colors'] as List<dynamic>?)?.cast<String>() ?? [],
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: json['review_count'] as int? ?? 0,
      inStock: json['in_stock'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }
}

/// Cart item
class CartItem {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get total => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
