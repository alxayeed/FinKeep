import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spendly/core/styles/app_colors.dart';

enum CustomNavBarStyle { floatingPill, indicatorLine, glowingBlob }

class CustomNavBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const CustomNavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomNavBarItem> items;
  final CustomNavBarStyle style;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.style = CustomNavBarStyle.floatingPill,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case CustomNavBarStyle.floatingPill:
        return _buildFloatingPill(context);
      case CustomNavBarStyle.indicatorLine:
        return _buildIndicatorLine(context);
      case CustomNavBarStyle.glowingBlob:
        return _buildGlowingBlob(context);
    }
  }

  // Style 1: Floating Glassmorphic Capsule/Pill (Blends dynamically with underlying content via blur)
  Widget _buildFloatingPill(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Using highly transparent backgrounds with blur for blending
    final Color barBgColor = isDark
        ? AppColors.bgDark.withOpacity(0.7)
        : Colors.white.withOpacity(0.75);
    final Color activeColor = AppColors.primaryTeal;
    final Color inactiveColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 14.0,
        top: 6.0,
      ),
      // ClipRRect is required for BackdropFilter to shape with the border radius
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: barBgColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : AppColors.primaryTeal.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final isSelected = index == currentIndex;
                final item = items[index];

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryTeal.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AnimatedScale(
                            scale: isSelected ? 1.12 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? activeColor : inactiveColor,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? activeColor : inactiveColor,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Style 2: Flat Bottom Bar (Blends naturally by matching the exact screen background)
  Widget _buildIndicatorLine(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Match the screen background exactly for seamless blending
    final Color barBgColor = isDark ? AppColors.bgDark : AppColors.bgLight;
    final Color activeColor = AppColors.primaryTeal;
    final Color inactiveColor = isDark ? Colors.grey[500]! : Colors.grey[500]!;

    return Container(
      decoration: BoxDecoration(
        color: barBgColor,
        // Using an ultra-subtle top gradient/shadow instead of a hard line for blending
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.08 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = index == currentIndex;
              final item = items[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        top: 0,
                        height: 3,
                        width: isSelected ? 32 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: activeColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                          ),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 4),
                          AnimatedScale(
                            scale: isSelected ? 1.08 : 1.0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? activeColor : inactiveColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected ? activeColor : inactiveColor,
                            ),
                            child: Text(item.label),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // Style 3: Liquid Glass Blob (Premium hybrid blending with soft shadow and matched background)
  Widget _buildGlowingBlob(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Blends by using a soft screen background match with blur
    final Color barBgColor = isDark
        ? AppColors.bgDark.withOpacity(0.9)
        : AppColors.bgLight.withOpacity(0.9);
    final Color inactiveColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: barBgColor,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final isSelected = index == currentIndex;
                  final item = items[index];

                  return GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isSelected ? 110 : 50,
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryTeal
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryTeal.withOpacity(
                                    0.25,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected ? Colors.white : inactiveColor,
                            size: 22,
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
