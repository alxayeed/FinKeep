import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

class StyledMultiSelectWidget<T> extends StatelessWidget {
  final List<T> items;
  final Set<T> selectedItems;
  final ValueChanged<Set<T>> onSelectionChanged;
  final String Function(T item) titleExtractor;
  final Widget Function(BuildContext context, T item, bool isSelected)? leadingBuilder;
  final bool showSelectAll;
  final String selectAllText;

  const StyledMultiSelectWidget({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    required this.titleExtractor,
    this.leadingBuilder,
    this.showSelectAll = true,
    this.selectAllText = 'Select All',
  });

  bool get _isAllSelected =>
      items.isNotEmpty && selectedItems.length == items.length;

  void _toggleSelectAll() {
    if (_isAllSelected) {
      onSelectionChanged(<T>{});
    } else {
      onSelectionChanged(items.toSet());
    }
  }

  void _toggleItem(T item) {
    final updated = Set<T>.from(selectedItems);
    if (updated.contains(item)) {
      updated.remove(item);
    } else {
      updated.add(item);
    }
    onSelectionChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSelectAll && items.isNotEmpty) ...[
          Material(
            color: _isAllSelected
                ? AppColors.primaryTeal.withValues(alpha: isDark ? 0.15 : 0.08)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                color: _isAllSelected ? AppColors.primaryTeal : borderColor,
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: _toggleSelectAll,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  children: [
                    Icon(
                      _isAllSelected
                          ? Icons.check_box_rounded
                          : (selectedItems.isNotEmpty
                              ? Icons.indeterminate_check_box_rounded
                              : Icons.check_box_outline_blank_rounded),
                      color: selectedItems.isNotEmpty
                          ? AppColors.primaryTeal
                          : (isDark ? Colors.white54 : const Color(0xFF94A3B8)),
                      size: 22.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        selectAllText,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: _isAllSelected ? AppColors.primaryTeal : textColor,
                        ),
                      ),
                    ),
                    Text(
                      '${selectedItems.length}/${items.length}',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 14.h,
            thickness: 0.5,
            color: borderColor,
          ),
          SizedBox(height: 2.h),
        ],
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selectedItems.contains(item);

            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Material(
                color: isSelected
                    ? AppColors.primaryTeal.withValues(alpha: isDark ? 0.15 : 0.08)
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryTeal : borderColor,
                    width: isSelected ? 1.2 : 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => _toggleItem(item),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: isSelected
                              ? AppColors.primaryTeal
                              : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                          size: 20.sp,
                        ),
                        if (leadingBuilder != null) ...[
                          SizedBox(width: 8.w),
                          leadingBuilder!(context, item, isSelected),
                        ],
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            titleExtractor(item),
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: 13.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
