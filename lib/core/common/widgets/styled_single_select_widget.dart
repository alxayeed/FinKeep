import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

class StyledSingleSelectWidget<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T> onSelected;
  final String Function(T item) titleExtractor;
  final Widget Function(BuildContext context, T item, bool isSelected)?
  leadingBuilder;
  final Widget Function(BuildContext context, T item, bool isSelected)?
  trailingBuilder;

  const StyledSingleSelectWidget({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    required this.titleExtractor,
    this.leadingBuilder,
    this.trailingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedItem == item;

        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryTeal.withValues(alpha: isDark ? 0.15 : 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryTeal : Colors.transparent,
              width: 1,
            ),
          ),
          child: ListTile(
            leading: leadingBuilder?.call(context, item, isSelected),
            title: Text(
              titleExtractor(item),
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13.sp,
                color: textColor,
              ),
            ),
            trailing: trailingBuilder?.call(context, item, isSelected),
            onTap: () => onSelected(item),
          ),
        );
      },
    );
  }
}
