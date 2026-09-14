import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/constants.dart';
import '../router/app_router.dart';

/// Bottom navigation shell for main app screens
class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          child,
          // Floating navbar overlay
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BlobNavBar(),
          ),
        ],
      ),
    );
  }
}

class _BlobNavBar extends StatelessWidget {
  const _BlobNavBar();

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 34),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.gray900,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            // Main shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 0,
            ),
            // Secondary shadow for more depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BlobNavItem(
              icon: PhosphorIcons.house(PhosphorIconsStyle.fill),
              isSelected: currentIndex == 0,
              onTap: () => _onItemTapped(context, 0),
            ),
            _BlobNavItem(
              icon: PhosphorIcons.barbell(PhosphorIconsStyle.fill),
              isSelected: currentIndex == 1,
              onTap: () => _onItemTapped(context, 1),
            ),
            _BlobNavItem(
              icon: PhosphorIcons.target(PhosphorIconsStyle.fill),
              isSelected: currentIndex == 2,
              onTap: () => _onItemTapped(context, 2),
            ),
            _BlobNavItem(
              icon: PhosphorIcons.forkKnife(PhosphorIconsStyle.fill),
              isSelected: currentIndex == 3,
              onTap: () => _onItemTapped(context, 3),
            ),
            _BlobNavItem(
              icon: PhosphorIcons.user(PhosphorIconsStyle.fill),
              isSelected: currentIndex == 4,
              onTap: () => _onItemTapped(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == AppRoutes.home) return 0;
    if (location.startsWith('/workouts')) return 1;
    if (location.startsWith('/challenges')) return 2;
    if (location.startsWith('/nutrition')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.workouts);
        break;
      case 2:
        context.go(AppRoutes.challenges);
        break;
      case 3:
        context.go(AppRoutes.nutrition);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }
}

class _BlobNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BlobNavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.gray900 : AppColors.gray400,
          ),
        ),
      ),
    );
  }
}
