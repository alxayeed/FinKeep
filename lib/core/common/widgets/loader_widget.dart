import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
        strokeWidth: 3,
      ),
    );
  }
}
