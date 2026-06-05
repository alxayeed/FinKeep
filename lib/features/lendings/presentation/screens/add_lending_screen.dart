import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

import '../../../../core/common/widgets/widgets.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/lending_person/lending_person_entity.dart';

class AddLendingScreen extends StatefulWidget {
  const AddLendingScreen({super.key});

  @override
  State<AddLendingScreen> createState() => _AddLendingScreenState();
}

class _AddLendingScreenState extends State<AddLendingScreen> {
  final LendingsController controller = Get.find();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final Map<LendingStatus, String> _statusLabels = {
    LendingStatus.due: 'Due / Unpaid',
    LendingStatus.partial: 'Partial Repayment',
    LendingStatus.overdue: 'Overdue',
    LendingStatus.paid: 'Fully Repaid',
  };

  // 0 = Given, 1 = Taken
  int _selectedType = 0;
  LendingStatus _selectedStatus = LendingStatus.due;
  DateTime _transactionDate = DateTime.now();
  DateTime? _dueDate;

  @override
  void dispose() {
    amountController.dispose();
    personNameController.dispose();
    contactController.dispose();
    descriptionController.dispose();
    super.dispose();
  }



  Future<void> _save() async {
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedAmount <= 0) {
      _showSnack('Please enter a valid amount.', isError: true);
      return;
    }
    if (personNameController.text.trim().isEmpty) {
      _showSnack('Please enter the person\'s name.', isError: true);
      return;
    }

    final lending = LendingEntity(
      id: '',
      personId: '',
      userId: controller.userId,
      person: LendingPersonEntity(
        id: '',
        userId: controller.userId,
        name: personNameController.text.trim(),
        contactNumber: contactController.text.trim().isEmpty
            ? null
            : contactController.text.trim(),
      ),
      amount: parsedAmount,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      type: _selectedType == 0 ? LendingType.given : LendingType.taken,
      status: _selectedStatus,
      dueDate: _dueDate,
      createdDate: _transactionDate,
    );

    await controller.addLending(
      lending,
      onSuccess: () {
        if (!mounted) return;
        _showSnack('Lending record saved!');
        context.pop();
      },
      onError: (e) {
        if (!mounted) return;
        _showSnack('Failed to save: $e', isError: true);
      },
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.error : AppColors.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Drag handle ──
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // ── App bar row ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left,
                            size: 22.sp, color: AppColors.primaryTeal),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'New Record',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 60.w),
                ],
              ),
            ),

            // ── Form ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // ── Given / Taken toggle ──
                        Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            children: [
                              _typeTab('Money Given', 0, isDark),
                              _typeTab('Money Taken', 1, isDark),
                            ],
                          ),
                        ),

                        SizedBox(height: 28.h),

                        // ── Big amount ──
                        StyledAmountField(
                          controller: amountController,
                          labelText: 'Amount',
                          autofocus: true,
                        ),

                        SizedBox(height: 28.h),

                        // ── Person Name ──
                        StyledTextFormField(
                          controller: personNameController,
                          labelText: 'Person Name',
                          hintText: 'Who did you lend to?',
                          prefixIcon: Icons.person_outline_rounded,
                        ),

                        SizedBox(height: 12.h),

                        // ── Contact ──
                        StyledTextFormField(
                          controller: contactController,
                          labelText: 'Contact Number',
                          hintText: '+880 1XXX-XXXXXX',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: 12.h),

                        // ── Status dropdown ──
                        StyledDropdownFormField<LendingStatus>(
                          value: _selectedStatus,
                          labelText: 'Current Status',
                          prefixIcon: Icons.check_circle_outline_rounded,
                          items: LendingStatus.values.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(_statusLabels[s] ?? s.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedStatus = val);
                          },
                        ),

                        SizedBox(height: 12.h),

                        // ── Date row ──
                        Row(
                          children: [
                            Expanded(
                              child: StyledDatePickerButton(
                                labelText: 'Transaction Date',
                                selectedDate: _transactionDate,
                                onDateSelected: (date) {
                                  if (date != null) {
                                    setState(() => _transactionDate = date);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: StyledDatePickerButton(
                                labelText: 'Due Date',
                                hintText: 'Not set',
                                selectedDate: _dueDate,
                                onDateSelected: (date) =>
                                    setState(() => _dueDate = date),
                                isOptional: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // ── Notes ──
                        StyledTextFormField(
                          controller: descriptionController,
                          labelText: 'Notes',
                          hintText: 'What was this for? (e.g., Lunch, Project gear)',
                          prefixIcon: Icons.description_rounded,
                          maxLines: 3,
                        ),

                        SizedBox(height: 28.h),

                        // ── Save button ──
                        ElevatedButton(
                          onPressed:
                              controller.isLoading.value ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 54.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 2,
                            shadowColor:
                                AppColors.primaryTeal.withValues(alpha: 0.2),
                          ),
                          child: controller.isLoading.value
                              ? SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save_alt_rounded,
                                        size: 18.sp),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Save Record',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),

                        SizedBox(height: 40.h),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────

  Widget _typeTab(String label, int index, bool isDark) {
    final isActive = _selectedType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(11.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 4.r,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? AppColors.primaryTeal
                  : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
            ),
          ),
        ),
      ),
    );
  }

}
