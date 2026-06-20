import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../responsive/responsive.dart';
import '../../styles/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title = "FinKeep",
    this.bottom,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      centerTitle: true,
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
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 26.sp,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              onPressed: () => context.pop(),
            )
          : null,
      actions: actions,
      bottom: bottom,
    );
  }
}
