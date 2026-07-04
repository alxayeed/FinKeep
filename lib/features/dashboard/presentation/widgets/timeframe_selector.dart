import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/dashboard_timeframe.dart';
import '../controllers/dashboard_controller.dart';

class TimeframeSelector extends StatelessWidget {
  const TimeframeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final selected = controller.timeframe.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: DashboardTimeframe.values.map((tf) {
            final isSelected = selected == tf;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(tf.displayName),
                selected: isSelected,
                selectedColor: AppColors.primaryTeal,
                backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primaryTeal
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                onSelected: (selected) {
                  if (selected) {
                    if (tf == DashboardTimeframe.custom) {
                      _selectCustomRange(context, controller);
                    } else {
                      controller.updateTimeframe(tf);
                    }
                  }
                },
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Future<void> _selectCustomRange(
    BuildContext context,
    DashboardController controller,
  ) async {
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: controller.customStartDate.value ?? now.subtract(const Duration(days: 30)),
      end: controller.customEndDate.value ?? now,
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initialRange,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppColors.primaryTeal,
                    onPrimary: Colors.white,
                    surface: AppColors.cardDark,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: AppColors.primaryTeal,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setCustomRange(picked.start, picked.end);
    }
  }
}
