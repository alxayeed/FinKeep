import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'widgets.dart';

class StyledCategorySelectorField<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<T> items;
  final String Function(T) titleExtractor;
  final Widget Function(BuildContext, T, bool)? leadingBuilder;
  final void Function(T) onSelected;
  final IconData prefixIcon;
  final String placeholder;

  const StyledCategorySelectorField({
    super.key,
    required this.value,
    required this.labelText,
    required this.items,
    required this.titleExtractor,
    required this.onSelected,
    this.leadingBuilder,
    this.prefixIcon = Icons.category_rounded,
    this.placeholder = 'Select Category',
  });

  void _showSelectorSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select $labelText',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 16.h),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: StyledSingleSelectWidget<T>(
                    items: items,
                    selectedItem: value ?? items.first,
                    onSelected: (item) {
                      onSelected(item);
                      Navigator.pop(sheetContext);
                    },
                    titleExtractor: titleExtractor,
                    leadingBuilder: leadingBuilder,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);

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
          onTap: () => _showSelectorSheet(context),
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
                // Show leading widget if value is not null and builder is provided
                if (value != null && leadingBuilder != null) ...[
                  leadingBuilder!(context, value as T, true),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Text(
                    value == null ? placeholder : titleExtractor(value as T),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      color: value == null
                          ? (isDark ? Colors.white24 : const Color(0xFFCBD5E1))
                          : (isDark ? Colors.white : const Color(0xFF334155)),
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
