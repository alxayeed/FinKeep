import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import 'package:finkeep/core/common/widgets/widgets.dart';
import '../controllers/income_category_controller.dart';

class IncomeCategorySettingsScreen extends StatefulWidget {
  const IncomeCategorySettingsScreen({super.key});

  @override
  State<IncomeCategorySettingsScreen> createState() => _IncomeCategorySettingsScreenState();
}

class _IncomeCategorySettingsScreenState extends State<IncomeCategorySettingsScreen> {
  final IncomeCategoryController categoryController = Get.find();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController(text: '💰');



  @override
  void dispose() {
    _labelController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category label.')),
      );
      return;
    }

    final emoji = _emojiController.text.trim().isEmpty ? '💰' : _emojiController.text.trim();
    final success = await categoryController.createCategory(
      displayLabel: label,
      emoji: emoji,
    );

    if (success) {
      _labelController.clear();
      _emojiController.text = '💰';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => const CustomAlertDialog(
            title: 'Category Limit Reached',
            description: 'You can create a maximum of 3 custom income categories. Please delete an existing custom category to add a new one.',
            buttonText: 'Got It',
          ),
        );
      }
    }
  }

  void _confirmDelete(String id, String label) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete the category "$label"? historical logs will remain safe.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await categoryController.softDeleteCategory(id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category successfully deleted.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = AppColors.primaryTeal;
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        elevation: 0,
        leadingWidth: 80.w,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: Icon(Icons.chevron_left, size: 24.sp, color: primaryColor),
          label: Text(
            'Back',
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Income Categories',
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Category list section
          Expanded(
            child: Obx(() {
              final active = categoryController.categories.where((c) => !c.isDeleted).toList();

              if (active.isEmpty) {
                return const Center(child: Text('No categories found.'));
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                itemCount: active.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final cat = active[index];

                  return Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat.emoji,
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.displayLabel,
                                style: AppTextStyles.cardTitle(context),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                cat.isCustom ? 'Custom Category' : 'Core Category',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'Manrope',
                                  color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Deleting is only allowed for custom categories
                        if (cat.isCustom)
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            onPressed: () => _confirmDelete(cat.id, cat.displayLabel),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // 2. Add category input pane
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ADD CUSTOM CATEGORY',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Obx(() => Text(
                        '${categoryController.customCategoryCount}/${categoryController.maxCustomCategoryLimit}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: categoryController.customCategoryCount >= categoryController.maxCustomCategoryLimit
                              ? AppColors.error
                              : (isDark ? Colors.white30 : const Color(0xFF94A3B8)),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 12.h),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emoji button selector Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
                            child: Text(
                              'Emoji',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 54.w,
                            height: 52.h,
                            child: TextField(
                              controller: _emojiController,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              maxLength: 1,
                              maxLines: null,
                              minLines: null,
                              expands: true,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF334155),
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: '💰',
                                hintStyle: TextStyle(
                                  fontSize: 18.sp,
                                  color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      // Text label field
                      Expanded(
                        child: AppTextField(
                          controller: _labelController,
                          labelText: 'Category Name',
                          hintText: 'Category Name (e.g. Rent, Gift)',
                          prefixIcon: Icons.edit_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _addCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Save Category',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
