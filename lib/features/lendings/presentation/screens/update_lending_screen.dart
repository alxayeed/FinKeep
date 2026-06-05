import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../../../core/routes/app_router.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../controllers/lendings_controller.dart';

class UpdateLendingScreen extends StatefulWidget {
  final LendingEntity lending;

  const UpdateLendingScreen({super.key, required this.lending});

  @override
  State<UpdateLendingScreen> createState() => _UpdateLendingScreenState();
}

class _UpdateLendingScreenState extends State<UpdateLendingScreen> {
  final LendingsController controller = Get.find<LendingsController>();

  late TextEditingController amountController;
  late TextEditingController personNameController;
  late TextEditingController contactController;
  late TextEditingController descriptionController;

  late int _selectedType; // 0 = given, 1 = taken
  late LendingStatus _selectedStatus;
  late DateTime _transactionDate;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    final l = widget.lending;

    amountController = TextEditingController(text: l.amount.toString());
    personNameController = TextEditingController(text: l.person.name);
    contactController =
        TextEditingController(text: l.person.contactNumber ?? '');
    descriptionController =
        TextEditingController(text: l.description ?? '');

    _selectedType = l.type == LendingType.given ? 0 : 1;
    _selectedStatus = l.status;
    _transactionDate = l.createdDate;
    _dueDate = l.dueDate;
  }

  @override
  void dispose() {
    amountController.dispose();
    personNameController.dispose();
    contactController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDue}) async {
    final initial = isDue ? (_dueDate ?? DateTime.now()) : _transactionDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: isDue
          ? DateTime.now().subtract(const Duration(days: 365))
          : DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: DateTime(2101),
      builder: (context, child) => _datePickerTheme(context, child!),
    );
    if (picked == null) return;
    setState(() {
      if (isDue) {
        _dueDate = picked;
      } else {
        _transactionDate = picked;
      }
    });
  }

  Widget _datePickerTheme(BuildContext context, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: isDark
          ? ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primaryTeal,
                onPrimary: Colors.white,
                surface: AppColors.cardDark,
                onSurface: Colors.white,
              ),
            )
          : ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryTeal,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Color(0xFF0F172A),
              ),
            ),
      child: child,
    );
  }

  Future<void> _update() async {
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedAmount <= 0) {
      _showSnack('Please enter a valid amount.', isError: true);
      return;
    }

    final updated = LendingEntity(
      id: widget.lending.id,
      userId: widget.lending.userId,
      personId: widget.lending.person.id,
      person: widget.lending.person,
      amount: parsedAmount,
      repaidAmount: widget.lending.repaidAmount,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      type: _selectedType == 0 ? LendingType.given : LendingType.taken,
      status: _selectedStatus,
      createdDate: _transactionDate,
      dueDate: _dueDate,
      repayments: widget.lending.repayments,
    );

    await controller.updateLending(
      updated,
      onSuccess: () {
        if (!mounted) return;
        _showSnack('Lending record updated!');
        context.pop();
        context.pushReplacementNamed(AppRoutes.lendings);
      },
      onError: (e) {
        if (!mounted) return;
        _showSnack('Failed to update: $e', isError: true);
      },
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          title: Text(
            'Delete Record?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            'This will permanently remove the lending record for ${widget.lending.person.name}. This action cannot be undone.',
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.error,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await controller.deleteLending(
      widget.lending.id,
      onSuccess: () {
        if (!mounted) return;
        _showSnack('Record deleted.');
        context.pop();
        context.pushReplacementNamed(AppRoutes.lendings);
      },
      onError: (e) {
        if (!mounted) return;
        _showSnack('Failed to delete: $e', isError: true);
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
    final Color inputBg =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor =
        isDark ? Colors.white60 : const Color(0xFF64748B);

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
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
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
                    'Edit Record',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Obx(() => TextButton(
                        onPressed:
                            controller.isLoading.value ? null : _update,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: controller.isLoading.value
                                ? Colors.grey
                                : AppColors.primaryTeal,
                          ),
                        ),
                      )),
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
                              _typeTab('Given', 0, isDark),
                              _typeTab('Taken', 1, isDark),
                            ],
                          ),
                        ),

                        SizedBox(height: 28.h),

                        // ── Big amount ──
                        Text(
                          'AMOUNT',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: labelColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: FaIcon(
                                FontAwesomeIcons.bangladeshiTakaSign,
                                size: 26.sp,
                                color: isDark
                                    ? Colors.white30
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            IntrinsicWidth(
                              child: TextField(
                                controller: amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 42.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white12
                                        : const Color(0xFFE2E8F0),
                                    fontSize: 42.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // ── Transaction Details heading ──
                        Text(
                          'Transaction Details',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 14.h),

                        // ── Person Name (read-only) ──
                        _label('Person Name', labelColor),
                        _inputField(
                          controller: personNameController,
                          hint: 'Person name',
                          icon: Icons.person_outline_rounded,
                          inputBg: inputBg,
                          isDark: isDark,
                          readOnly: true,
                        ),

                        SizedBox(height: 12.h),

                        // ── Contact (read-only) ──
                        _label('Contact Info', labelColor),
                        _inputField(
                          controller: contactController,
                          hint: 'No contact info',
                          icon: Icons.phone_outlined,
                          inputBg: inputBg,
                          isDark: isDark,
                          keyboardType: TextInputType.phone,
                          readOnly: true,
                        ),

                        SizedBox(height: 12.h),

                        // ── Due date + Status ──
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Due Date', labelColor),
                                  _datePicker(
                                    date: _dueDate,
                                    inputBg: inputBg,
                                    isDark: isDark,
                                    onTap: () => _pickDate(isDue: true),
                                    placeholder: 'Not set',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Status', labelColor),
                                  _statusDropdown(inputBg, isDark),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // ── Notes ──
                        _label('Notes', labelColor, trailing: 'Optional'),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 14.h),
                                child: Icon(Icons.description_rounded,
                                    size: 18.sp,
                                    color: isDark
                                        ? Colors.white38
                                        : const Color(0xFF94A3B8)),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextField(
                                  controller: descriptionController,
                                  maxLines: 3,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF334155),
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'What was this for? (e.g., Lunch, Project gear)',
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.white24
                                          : const Color(0xFFCBD5E1),
                                      fontSize: 13.sp,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 28.h),

                        // ── Update Record button ──
                        ElevatedButton(
                          onPressed:
                              controller.isLoading.value ? null : _update,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 54.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 2,
                            shadowColor: AppColors.primaryTeal
                                .withValues(alpha: 0.2),
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
                              : Text(
                                  'Update Record',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),

                        SizedBox(height: 12.h),

                        // ── Delete Record button ──
                        GestureDetector(
                          onTap: _confirmDelete,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline_rounded,
                                    size: 18.sp,
                                    color: AppColors.error),
                                SizedBox(width: 6.w),
                                Text(
                                  'Delete Record',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),
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
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, Color color, {String? trailing}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color inputBg,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18.sp,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF334155),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                  fontSize: 13.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusDropdown(Color inputBg, bool isDark) {
    final statusLabels = {
      LendingStatus.due: 'Due / Unpaid',
      LendingStatus.partial: 'Partial Repayment',
      LendingStatus.overdue: 'Overdue',
      LendingStatus.paid: 'Fully Repaid',
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LendingStatus>(
          value: _selectedStatus,
          isExpanded: true,
          icon: Icon(Icons.expand_more_rounded,
              size: 18.sp,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF334155),
          ),
          onChanged: (val) {
            if (val != null) setState(() => _selectedStatus = val);
          },
          items: LendingStatus.values.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(statusLabels[s] ?? s.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _datePicker({
    required DateTime? date,
    required Color inputBg,
    required bool isDark,
    required VoidCallback onTap,
    String? placeholder,
  }) {
    final text = date != null
        ? DateFormat('MMM dd, yyyy').format(date)
        : (placeholder ?? '');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 14.sp,
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: date == null
                      ? (isDark ? Colors.white24 : const Color(0xFFCBD5E1))
                      : (isDark ? Colors.white : const Color(0xFF334155)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
