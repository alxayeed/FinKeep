import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'styled_multi_select_widget.dart';

class StyledMultiCategorySelectorField<T> extends StatelessWidget {
  final Set<T> selectedItems;
  final String labelText;
  final List<T> items;
  final String Function(T) titleExtractor;
  final Widget Function(BuildContext, T, bool)? leadingBuilder;
  final ValueChanged<Set<T>> onSelectionChanged;
  final IconData prefixIcon;
  final String placeholder;
  final String allSelectedText;

  const StyledMultiCategorySelectorField({
    super.key,
    required this.selectedItems,
    required this.labelText,
    required this.items,
    required this.titleExtractor,
    required this.onSelectionChanged,
    this.leadingBuilder,
    this.prefixIcon = Icons.category_rounded,
    this.placeholder = 'Select Categories',
    this.allSelectedText = 'All Categories',
  });

  String _getDisplayText() {
    if (selectedItems.isEmpty || selectedItems.length == items.length) {
      return allSelectedText;
    }
    if (selectedItems.length == 1) {
      return titleExtractor(selectedItems.first);
    }
    if (selectedItems.length == 2) {
      final list = selectedItems.toList();
      return '${titleExtractor(list[0])}, ${titleExtractor(list[1])}';
    }
    final list = selectedItems.toList();
    final remaining = selectedItems.length - 2;
    return '${titleExtractor(list[0])}, ${titleExtractor(list[1])} +$remaining more';
  }

  void _showMultiSelectorSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Set<T> tempSelected = Set<T>.from(
      selectedItems.isEmpty ? items : selectedItems,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 14.h),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Select $labelText',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20.sp,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // List of categories with Multi-Select
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(sheetContext).size.height * 0.55,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: StyledMultiSelectWidget<T>(
                        items: items,
                        selectedItems: tempSelected,
                        onSelectionChanged: (updated) {
                          setSheetState(() {
                            tempSelected = updated;
                          });
                        },
                        titleExtractor: titleExtractor,
                        leadingBuilder: leadingBuilder,
                        showSelectAll: true,
                        selectAllText: 'Select All',
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Done Button
                  ElevatedButton(
                    onPressed: () {
                      onSelectionChanged(tempSelected);
                      Navigator.of(sheetContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Done (${tempSelected.length == items.length || tempSelected.isEmpty ? "All" : tempSelected.length})',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final isAll = selectedItems.isEmpty || selectedItems.length == items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
          child: Text(
            labelText,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
        ),
        InkWell(
          onTap: () => _showMultiSelectorSheet(context),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  prefixIcon,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    _getDisplayText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      fontWeight: isAll ? FontWeight.w500 : FontWeight.bold,
                      color: isAll
                          ? (isDark ? Colors.white70 : const Color(0xFF475569))
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
