import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import 'edit_expense_screen.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  final ExpenseEntity expense;

  const ExpenseDetailsScreen({super.key, required this.expense});

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  final ExpenseController controller = Get.find();
  late ExpenseEntity _currentExpense;

  @override
  void initState() {
    super.initState();
    _currentExpense = widget.expense;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color categoryColor;
    IconData categoryIcon;

    switch (_currentExpense.category.toLowerCase()) {
      case 'food':
        categoryColor = Colors.orange.shade600;
        categoryIcon = Icons.restaurant_rounded;
        break;
      case 'transport':
        categoryColor = const Color(0xFF059669);
        categoryIcon = Icons.directions_car_rounded;
        break;
      case 'family':
        categoryColor = Colors.blue.shade600;
        categoryIcon = Icons.family_restroom_rounded;
        break;
      case 'personal':
        categoryColor = Colors.purple.shade600;
        categoryIcon = Icons.person_rounded;
        break;
      case 'lend':
        categoryColor = Colors.teal.shade600;
        categoryIcon = Icons.handshake_rounded;
        break;
      case 'clothing':
        categoryColor = Colors.pink.shade600;
        categoryIcon = Icons.shopping_bag_rounded;
        break;
      case 'hangout':
        categoryColor = Colors.amber.shade700;
        categoryIcon = Icons.local_activity_rounded;
        break;
      case 'utilities':
        categoryColor = Colors.indigo.shade600;
        categoryIcon = Icons.bolt_rounded;
        break;
      default:
        categoryColor = const Color(0xFF475569);
        categoryIcon = Icons.category_rounded;
    }

    final formattedDate = DateFormat('MMMM dd, yyyy').format(_currentExpense.date);
    final formattedTime = DateFormat('hh:mm a').format(_currentExpense.date);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        elevation: 0,
        leadingWidth: 80.w,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: Icon(Icons.chevron_left, size: 24.sp, color: const Color(0xFF007AFF)),
          label: Text(
            'Back',
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              color: const Color(0xFF007AFF),
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Expense Details',
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updated = await context.pushNamed<ExpenseEntity>(
                AppRoutes.editExpense,
                extra: _currentExpense,
              );
              if (updated != null && mounted) {
                setState(() {
                  _currentExpense = updated;
                });
              }
            },
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                color: const Color(0xFF007AFF),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Center Header Panel (Icon, Category, Amount, Date)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
              child: Column(
                children: [
                  Container(
                    width: 64.r,
                    height: 64.r,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    _currentExpense.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: isDark ? Colors.white38 : const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _currentExpense.amount.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      FaIcon(
                        FontAwesomeIcons.bangladeshiTakaSign,
                        size: 18.sp,
                        color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '$formattedDate at $formattedTime',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            // Metadata Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // 1. Status / Payment Card
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildRowItem(
                          context,
                          'Status',
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8.r,
                                height: 8.r,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          showDivider: true,
                        ),
                        _buildRowItem(
                          context,
                          'Payment Method',
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'CASH',
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Cash Payment',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // 2. Description Note Card
                  if (_currentExpense.description.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NOTE',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _currentExpense.description,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.4.h,
                              color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 16.h),

                  // 3. Image Receipt Card (Dashed)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        width: 1,
                        style: BorderStyle.solid, // solid fallback border in Flutter
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 32.sp,
                          color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Add Receipt Image',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Action Buttons
                  Column(
                    children: [
                      // Share/Export Button
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Statement exported successfully!')),
                          );
                        },
                        icon: Icon(Icons.ios_share_rounded, size: 18.sp),
                        label: const Text('Export Statement'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFEEF0F2),
                          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                          minimumSize: Size(double.infinity, 48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Delete button
                      OutlinedButton.icon(
                        onPressed: () => _confirmDelete(context),
                        icon: Icon(Icons.delete_rounded, size: 18.sp, color: Colors.red.shade600),
                        label: Text(
                          'Delete Transaction',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade100, width: 1),
                          backgroundColor: Colors.red.shade50.withValues(alpha: 0.1),
                          minimumSize: Size(double.infinity, 48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(BuildContext context, String label, Widget trailing, {bool showDivider = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white38 : const Color(0xFF64748B),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.removeExpense(
        _currentExpense.id,
        onSuccess: () {
          if (!mounted) return;
          context.pushReplacementNamed(AppRoutes.expenses);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense successfully deleted.'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onError: (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete expense: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }
}
