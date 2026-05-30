import 'package:flutter/material.dart';
import '../../responsive/responsive.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const CustomFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF0F172A),
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      elevation: 6,
      onPressed: onPressed,
      child: Icon(icon, size: 28.sp),
    );
  }
}
