import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../responsive/responsive.dart';
import '../../styles/app_colors.dart';
import '../../providers/privacy_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final Widget? leading;
  final bool showPrivacyToggle;
  final bool centerTitle;
  final double? titleSpacing;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title = "FinKeep",
    this.bottom,
    this.showBackButton = false,
    this.leading,
    this.showPrivacyToggle = true,
    this.centerTitle = true,
    this.titleSpacing,
    this.actions,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          letterSpacing: 0.2,
        ),
      ),
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    size: 26.sp,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  onPressed: () => context.pop(),
                )
              : null),
      actions: [
        if (showPrivacyToggle)
          ValueListenableBuilder<bool>(
            valueListenable: PrivacyProvider(),
            builder: (context, isMasked, _) {
              if (!PrivacyProvider().isPrivacyModeEnabled) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(
                  isMasked
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 22.sp,
                  color: isMasked
                      ? (isDark ? Colors.white60 : const Color(0xFF64748B))
                      : AppColors.primaryTeal,
                ),
                onPressed: () => PrivacyProvider().toggleWithBiometrics(context),
              );
            },
          ),
        ...?actions,
      ],
      bottom: bottom,
    );
  }
}
