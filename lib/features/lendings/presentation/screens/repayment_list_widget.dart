import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';


import '../../../auth/presentation/controller/auth_controller.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/repayment/repayment_entity.dart';
import '../controllers/lendings_controller.dart';

class RepaymentListWidget extends StatefulWidget {
  final LendingEntity lending;

  const RepaymentListWidget({super.key, required this.lending});

  @override
  State<RepaymentListWidget> createState() => _RepaymentListWidgetState();
}

class _RepaymentListWidgetState extends State<RepaymentListWidget> {
  final LendingsController controller = Get.find<LendingsController>();

  @override
  void initState() {
    super.initState();
    controller.fetchRepayments(widget.lending.id);
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repayment History',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),

        // ── List ────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            if (controller.repaymentsList.isEmpty) {
              return _buildEmptyState(isDark);
            }

            // Show origin record at bottom + repayments sorted newest first
            final repayments = controller.repaymentsList.toList()
              ..sort((a, b) => b.paidDate.compareTo(a.paidDate));

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: repayments.length + 1, // +1 for origin row
              itemBuilder: (context, index) {
                // Last item = origin/created row
                if (index == repayments.length) {
                  return _buildOriginTile(isDark);
                }
                final repayment = repayments[index];
                return _buildRepaymentTile(repayment, index, isDark);
              },
            );
          }),
        ),

        SizedBox(height: 16.h),

        // ── Bottom CTA row ──────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
          child: Row(
            children: [
              // Add repayment CTA
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showRepaymentSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    minimumSize: Size(0, 52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 2,
                    shadowColor: AppColors.primaryTeal.withValues(alpha: 0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline_rounded, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Add Repayment',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // Edit record icon button
              GestureDetector(
                onTap: () {
                  // Edit the last / any repayment via the list
                  if (controller.repaymentsList.isNotEmpty) {
                    _showRepaymentSheet(context,
                        repayment: controller.repaymentsList.first);
                  }
                },
                child: Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Icon(Icons.edit_rounded,
                      size: 20.sp,
                      color: isDark ? Colors.white54 : const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Individual repayment tile ─────────────────────────────────
  Widget _buildRepaymentTile(
      RepaymentEntity repayment, int index, bool isDark) {
    final dateText =
        DateFormat('MMM dd, yyyy').format(repayment.paidDate);

    return Dismissible(
      key: ValueKey(repayment.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 22.sp),
      ),
      confirmDismiss: (dir) => _confirmDeleteRepayment(repayment),
      onDismissed: (_) => controller.deleteRepayment(repayment),
      child: GestureDetector(
        onTap: () => _showRepaymentSheet(context, repayment: repayment),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFF1F5F9),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon badge
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.payments_rounded,
                    size: 18.sp, color: AppColors.primaryTeal),
              ),
              SizedBox(width: 12.w),

              // Description + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repayment.notes?.isNotEmpty == true
                          ? repayment.notes!
                          : 'Repayment #${index + 1}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '+',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  Text(
                    '${repayment.amount.toCurrency()} ৳',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Origin / created tile ─────────────────────────────────────
  Widget _buildOriginTile(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C2B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.flag_outlined,
                size: 18.sp,
                color:
                    isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lending Record Created',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  DateFormat('MMM dd, yyyy')
                      .format(widget.lending.createdDate),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Manrope',
                    color: isDark
                        ? Colors.white24
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Originated',
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 48.sp,
              color: isDark ? Colors.white10 : Colors.black12),
          SizedBox(height: 12.h),
          Text(
            'No repayments yet',
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Tap "Add Repayment" below to record a payment',
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Manrope',
              color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Delete confirmation ───────────────────────────────────────
  Future<bool> _confirmDeleteRepayment(RepaymentEntity repayment) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Delete Repayment?',
            style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A))),
        content: Text(
          'Remove this repayment of ${repayment.amount.toCurrency()} ৳?',
          style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              color: isDark ? Colors.white60 : const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(
                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    fontFamily: 'Manrope')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: TextStyle(
                    color: AppColors.error,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  // ── Add / Edit repayment bottom sheet ─────────────────────────
  void _showRepaymentSheet(BuildContext context,
      {RepaymentEntity? repayment}) {
    final isEdit = repayment != null;
    final amountCtrl =
        TextEditingController(text: repayment?.amount.toString() ?? '');
    final notesCtrl =
        TextEditingController(text: repayment?.notes ?? '');
    final dateObs = Rx<DateTime?>(repayment?.paidDate ?? DateTime.now());
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        final isDark =
            Theme.of(modalContext).brightness == Brightness.dark;
        final Color inputBg = isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFFF1F5F9);
        final Color labelColor =
            isDark ? Colors.white60 : const Color(0xFF64748B);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 38.w,
                      height: 4.h,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    isEdit ? 'Edit Repayment' : 'Add Repayment',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Amount label
                  _label('Amount', labelColor),

                  // Amount input field
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.bangladeshiTakaSign,
                          size: 16.sp,
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextFormField(
                            controller: amountCtrl,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            autofocus: !isEdit,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF334155),
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? Colors.white24
                                    : const Color(0xFFCBD5E1),
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Enter an amount';
                              }
                              if (double.tryParse(val) == null ||
                                  double.parse(val) <= 0) {
                                return 'Enter a valid positive amount';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Date picker
                  _label('Payment Date', labelColor),
                  Obx(() => GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: modalContext,
                            initialDate:
                                dateObs.value ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (ctx, child) {
                              return Theme(
                                data: isDark
                                    ? ThemeData.dark().copyWith(
                                        colorScheme:
                                            const ColorScheme.dark(
                                          primary: AppColors.primaryTeal,
                                          onPrimary: Colors.white,
                                          surface: AppColors.cardDark,
                                          onSurface: Colors.white,
                                        ))
                                    : ThemeData.light().copyWith(
                                        colorScheme:
                                            const ColorScheme.light(
                                          primary: AppColors.primaryTeal,
                                          onPrimary: Colors.white,
                                        )),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) dateObs.value = picked;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_rounded,
                                  size: 16.sp,
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFF94A3B8)),
                              SizedBox(width: 10.w),
                              Text(
                                dateObs.value != null
                                    ? DateFormat('MMM dd, yyyy')
                                        .format(dateObs.value!)
                                    : 'Select date',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),

                  SizedBox(height: 12.h),

                  // Notes
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
                          padding: EdgeInsets.only(top: 13.h),
                          child: Icon(Icons.edit_note_rounded,
                              size: 18.sp,
                              color: isDark
                                  ? Colors.white38
                                  : const Color(0xFF94A3B8)),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: notesCtrl,
                            maxLines: 2,
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
                                  'e.g. Paid early as promised…',
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

                  SizedBox(height: 24.h),

                  // Save button
                  ElevatedButton(
                    onPressed: () => _saveRepayment(
                      modalContext,
                      formKey: formKey,
                      amountCtrl: amountCtrl,
                      notesCtrl: notesCtrl,
                      dateObs: dateObs,
                      existing: repayment,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      isEdit ? 'Update Repayment' : 'Save Repayment',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveRepayment(
    BuildContext modalContext, {
    required GlobalKey<FormState> formKey,
    required TextEditingController amountCtrl,
    required TextEditingController notesCtrl,
    required Rx<DateTime?> dateObs,
    RepaymentEntity? existing,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final isEdit = existing != null;
    final enteredAmount = double.parse(amountCtrl.text);

    // Overpayment guards
    final totalPaid = controller.repaymentsList.fold<double>(
        0, (s, r) => s + (r.id == existing?.id ? 0 : r.amount));
    final dueAmount = widget.lending.amount - totalPaid;

    if (!isEdit && dueAmount <= 0) {
      if (!mounted) return;
      showDialog(
        context: modalContext,
        builder: (ctx) => AlertDialog(
          title: const Text('Already Fully Repaid'),
          content: const Text(
              'This lending has already been fully repaid.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    if (!isEdit && enteredAmount > dueAmount) {
      final proceed = await showDialog<bool>(
        context: modalContext,
        builder: (ctx) => AlertDialog(
          title: const Text('Overpayment Warning'),
          content: Text(
            'Due amount is ${dueAmount.toCurrency()} ৳ but you entered '
            '${enteredAmount.toCurrency()} ৳. Proceed?',
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Proceed')),
          ],
        ),
      );
      if (proceed != true) return;
    }

    if (!mounted) return;

    final AuthController authController = Get.find();
    final newRepayment = RepaymentEntity(
      id: existing?.id ?? UniqueKey().toString(),
      lendingId: widget.lending.id,
      userId: authController.user?.email ?? 'unknown_user',
      amount: enteredAmount,
      paidDate: dateObs.value ?? DateTime.now(),
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
    );

    if (isEdit) {
      await controller.updateRepayment(newRepayment);
    } else {
      await controller.addRepayment(newRepayment);
    }

    if (!mounted) return;
    if (modalContext.mounted) Navigator.pop(modalContext);
  }

  Widget _label(String text, Color color, {String? trailing}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: color)),
          if (trailing != null)
            Text(trailing,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Manrope',
                    color: color.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}
