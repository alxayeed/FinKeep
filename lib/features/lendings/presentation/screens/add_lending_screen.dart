import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

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
                                autofocus: true,
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

                        SizedBox(height: 28.h),

                        // ── Person Name ──
                        _label('Person Name', labelColor),
                        _inputField(
                          controller: personNameController,
                          hint: 'Who did you lend to?',
                          icon: Icons.person_outline_rounded,
                          inputBg: inputBg,
                          isDark: isDark,
                        ),

                        SizedBox(height: 12.h),

                        // ── Contact ──
                        _label('Contact Number', labelColor,
                            trailing: 'Optional'),
                        _inputField(
                          controller: contactController,
                          hint: '+880 1XXX-XXXXXX',
                          icon: Icons.phone_outlined,
                          inputBg: inputBg,
                          isDark: isDark,
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: 12.h),

                        // ── Status dropdown ──
                        _label('Current Status', labelColor),
                        _statusDropdown(inputBg, isDark),

                        SizedBox(height: 12.h),

                        // ── Date row ──
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Transaction Date', labelColor),
                                  _datePicker(
                                    date: _transactionDate,
                                    inputBg: inputBg,
                                    isDark: isDark,
                                    onTap: () => _pickDate(isDue: false),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Due Date', labelColor,
                                      trailing: 'Optional'),
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
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 18.sp,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
          SizedBox(width: 10.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<LendingStatus>(
                value: _selectedStatus,
                icon: Icon(Icons.expand_more_rounded,
                    size: 20.sp,
                    color:
                        isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                dropdownColor:
                    isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color:
                      isDark ? Colors.white : const Color(0xFF334155),
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
          ),
        ],
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
        : (placeholder ?? DateFormat('MMM dd, yyyy').format(DateTime.now()));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 16.sp,
                color:
                    isDark ? Colors.white38 : const Color(0xFF94A3B8)),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: date == null
                      ? (isDark
                          ? Colors.white24
                          : const Color(0xFFCBD5E1))
                      : (isDark
                          ? Colors.white
                          : const Color(0xFF334155)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
