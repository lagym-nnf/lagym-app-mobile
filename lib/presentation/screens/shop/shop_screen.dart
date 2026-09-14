import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/product.dart';
import '../../../providers/products_provider.dart';

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product, {String? size, String? color}) {
    final existingIndex = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (existingIndex != -1) {
      // Increase quantity
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex].copyWith(quantity: state[existingIndex].quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Add new item
      state = [
        ...state,
        CartItem(product: product, selectedSize: size, selectedColor: color),
      ];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    state = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.total);
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  int _selectedCategory = 0;
  final _categories = ['All', 'Equipment', 'Apparel', 'Accessories', 'Supplements'];

  List<Product> _filteredProducts(List<Product> products) {
    if (_selectedCategory == 0) return products;
    final category = ProductCategory.values[_selectedCategory - 1];
    return products.where((p) => p.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.sm,
                      ),
                      child: Icon(PhosphorIcons.arrowLeft(), size: 20, color: AppColors.gray900),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Shop', style: AppTypography.greetingLarge),
                  const Spacer(),
                  // Cart button
                  GestureDetector(
                    onTap: () => _showCart(context),
                    child: Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.sm,
                          ),
                          child: Icon(PhosphorIcons.shoppingBag(), size: 20, color: AppColors.gray900),
                        ),
                        if (cart.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.pinkDark,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${ref.read(cartProvider.notifier).itemCount}',
                                  style: AppTypography.captionSmall.copyWith(
                                    color: AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Category tabs
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.gray900 : AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        _categories[index],
                        style: AppTypography.buttonSmall.copyWith(
                          color: isSelected ? AppColors.white : AppColors.gray600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Products grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(productsProvider),
                child: ref.watch(productsProvider).when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => ListView(
                        children: [
                          const SizedBox(height: 80),
                          Icon(PhosphorIcons.wifiSlash(),
                              size: 48, color: AppColors.gray300),
                          const SizedBox(height: 16),
                          Text(
                            'Could not load products.\nPull down to try again.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.gray500),
                          ),
                        ],
                      ),
                      data: (products) {
                        final filtered = _filteredProducts(products);
                        if (filtered.isEmpty) {
                          return ListView(
                            children: [
                              const SizedBox(height: 80),
                              Icon(PhosphorIcons.shoppingBag(),
                                  size: 48, color: AppColors.gray300),
                              const SizedBox(height: 16),
                              Text(
                                'No products here yet.\nCheck back soon!',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium
                                    .copyWith(color: AppColors.gray500),
                              ),
                            ],
                          );
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final product = filtered[index];
                            return _ProductCard(
                              product: product,
                              onTap: () =>
                                  _showProductDetails(context, product),
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProductDetailSheet(product: product),
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CartSheet(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.gray100,
                        child: Icon(PhosphorIcons.image(), color: AppColors.gray300, size: 32),
                      ),
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.pinkDark,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          '-${product.discountPercent.toInt()}%',
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.cardTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.reviewCount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(PhosphorIcons.star(PhosphorIconsStyle.fill), size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: AppTypography.captionSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' (${product.reviewCount})',
                          style: AppTypography.captionSmall.copyWith(color: AppColors.gray400),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '€${product.price.toStringAsFixed(2)}',
                        style: AppTypography.cardTitle.copyWith(color: AppColors.pinkDark),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          '€${product.originalPrice!.toStringAsFixed(2)}',
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.gray400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailSheet extends ConsumerStatefulWidget {
  final Product product;

  const _ProductDetailSheet({required this.product});

  @override
  ConsumerState<_ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends ConsumerState<_ProductDetailSheet> {
  String? _selectedSize;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.gray200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          height: 250,
                          color: AppColors.gray100,
                          child: Icon(PhosphorIcons.image(), color: AppColors.gray300, size: 48),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title and price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(widget.product.name, style: AppTypography.h2),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '€${widget.product.price.toStringAsFixed(2)}',
                              style: AppTypography.h2.copyWith(color: AppColors.pinkDark),
                            ),
                            if (widget.product.hasDiscount)
                              Text(
                                '€${widget.product.originalPrice!.toStringAsFixed(2)}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.gray400,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    if (widget.product.reviewCount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ...List.generate(5, (i) => Icon(
                            i < widget.product.rating.floor()
                                ? PhosphorIcons.star(PhosphorIconsStyle.fill)
                                : PhosphorIcons.star(),
                            size: 16,
                            color: Colors.amber,
                          )),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.product.rating} (${widget.product.reviewCount} reviews)',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Description
                    Text('Description', style: AppTypography.sectionTitle),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
                    ),

                    // Size selector
                    if (widget.product.sizes.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Size', style: AppTypography.sectionTitle),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: widget.product.sizes.map((size) {
                          final isSelected = _selectedSize == size;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedSize = size),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.gray900 : AppColors.white,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(
                                  color: isSelected ? AppColors.gray900 : AppColors.gray200,
                                ),
                              ),
                              child: Text(
                                size,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isSelected ? AppColors.white : AppColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Color selector
                    if (widget.product.colors.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Color', style: AppTypography.sectionTitle),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: widget.product.colors.map((color) {
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.gray900 : AppColors.white,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(
                                  color: isSelected ? AppColors.gray900 : AppColors.gray200,
                                ),
                              ),
                              child: Text(
                                color,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isSelected ? AppColors.white : AppColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Add to cart button
            Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addItem(
                      widget.product,
                      size: _selectedSize,
                      color: _selectedColor,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.name} added to cart'),
                        backgroundColor: AppColors.pinkDark,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: AppTypography.buttonMedium.copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSheet extends ConsumerWidget {
  const _CartSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your Cart', style: AppTypography.h2),
                      Text(
                        '${cartNotifier.itemCount} items',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cart items
            Expanded(
              child: cart.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(PhosphorIcons.shoppingBag(), size: 64, color: AppColors.gray300),
                          const SizedBox(height: 16),
                          Text('Your cart is empty', style: AppTypography.cardTitle.copyWith(color: AppColors.gray500)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              child: CachedNetworkImage(
                                imageUrl: item.product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  width: 70,
                                  height: 70,
                                  color: AppColors.gray100,
                                  child: Icon(PhosphorIcons.image(), color: AppColors.gray300),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: AppTypography.cardTitle),
                                  if (item.selectedSize != null || item.selectedColor != null)
                                    Text(
                                      [item.selectedSize, item.selectedColor].whereType<String>().join(' • '),
                                      style: AppTypography.captionSmall.copyWith(color: AppColors.gray500),
                                    ),
                                  Text(
                                    '€${item.product.price.toStringAsFixed(2)}',
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.pinkDark, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            // Quantity controls
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => cartNotifier.updateQuantity(item.product.id, item.quantity - 1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.gray100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(PhosphorIcons.minus(), size: 14, color: AppColors.gray600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('${item.quantity}', style: AppTypography.cardTitle),
                                ),
                                GestureDetector(
                                  onTap: () => cartNotifier.updateQuantity(item.product.id, item.quantity + 1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.pinkDark,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(PhosphorIcons.plus(), size: 14, color: AppColors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
            ),

            // Checkout section
            if (cart.isNotEmpty)
              Container(
                padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600)),
                        Text('€${cartNotifier.subtotal.toStringAsFixed(2)}', style: AppTypography.h3),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pinkDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: AppTypography.buttonMedium.copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
