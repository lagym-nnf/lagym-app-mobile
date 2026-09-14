import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/product.dart';

/// Provider for fetching all products
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final response = await SupabaseConfig.client
      .from('shop_products')
      .select()
      .eq('is_active', true)
      .order('sort_order');

  return (response as List).map((json) => _productFromJson(json)).toList();
});

/// Provider for fetching a single product by ID
final productProvider = FutureProvider.family<Product?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('shop_products')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return _productFromJson(response);
});

/// Provider for fetching featured products
final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final response = await SupabaseConfig.client
      .from('shop_products')
      .select()
      .eq('is_active', true)
      .eq('is_featured', true)
      .order('sort_order')
      .limit(6);

  return (response as List).map((json) => _productFromJson(json)).toList();
});

/// Provider for fetching products by category
final productsByCategoryProvider = FutureProvider.family<List<Product>, String>((ref, category) async {
  final response = await SupabaseConfig.client
      .from('shop_products')
      .select()
      .eq('is_active', true)
      .eq('category', category)
      .order('sort_order');

  return (response as List).map((json) => _productFromJson(json)).toList();
});

/// Helper to convert shop_products JSON to Product entity
Product _productFromJson(Map<String, dynamic> json) {
  final images = (json['images'] as List<dynamic>?)?.cast<String>() ?? [];
  final price = (json['price'] as num).toDouble();
  final salePrice = (json['sale_price'] as num?)?.toDouble();

  return Product(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    category: ProductCategory.values.firstWhere(
      (c) => c.name == json['category'],
      orElse: () => ProductCategory.equipment,
    ),
    // When a sale price is set it is what the customer pays; the regular
    // price becomes the crossed-out original.
    price: salePrice ?? price,
    originalPrice: salePrice != null ? price : null,
    imageUrl: images.isNotEmpty ? images.first : '',
    images: images,
    sizes: (json['sizes'] as List<dynamic>?)?.cast<String>() ?? [],
    colors: (json['colors'] as List<dynamic>?)?.cast<String>() ?? [],
    inStock: (json['stock_quantity'] as int? ?? 0) > 0,
    isFeatured: json['is_featured'] as bool? ?? false,
  );
}
