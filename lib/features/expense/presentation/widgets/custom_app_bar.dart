import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  const CustomAppBar({
    super.key,
    this.title = "Spendly",
    this.bottom
  });

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal,
      actions: const [],
      bottom: bottom,
    );
  }
}
