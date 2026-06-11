import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/widgets.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';
import 'package:spendly/core/enums/payment_type.dart';

import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';
import '../controller/investment_controller.dart';

class InvestmentStepperForm extends StatefulWidget {
  final Investment? initialInvestment;
  final String title;
  final bool allowStatusEdit;

  const InvestmentStepperForm({
    super.key,
    required this.title,
    this.initialInvestment,
    this.allowStatusEdit = false,
  });

  @override
  State<InvestmentStepperForm> createState() => _InvestmentStepperFormState();
}

class _InvestmentStepperFormState extends State<InvestmentStepperForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _platformController;
  late final TextEditingController _profitRateController;
  late final TextEditingController _expectedROIController;
  late final TextEditingController _notesController;
  late final TextEditingController _docLinksController;
  late final TextEditingController _transactionIdController;

  DateTime? _startDate;
  DateTime? _expectedEndDate;
  DateTime? _transactionDate;
  InvestmentStatus _status = InvestmentStatus.active;
  late PaymentType _paymentMethod;

  bool get isEdit => widget.initialInvestment != null;

  final InvestmentController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    final inv = widget.initialInvestment;

    _titleController = TextEditingController(text: inv?.title ?? '');
    _amountController = TextEditingController(
      text: inv?.amountInvested != null ? inv!.amountInvested.toStringAsFixed(0) : '',
    );
    _platformController = TextEditingController(text: inv?.platformName ?? '');
    _profitRateController = TextEditingController(text: inv?.profitRate ?? '');
    _expectedROIController = TextEditingController(
      text: inv?.expectedROI != null && inv!.expectedROI > 0 ? inv.expectedROI.toStringAsFixed(0) : '',
    );
    _notesController = TextEditingController(text: inv?.notes ?? '');
    _docLinksController = TextEditingController(text: inv?.docLinks ?? '');
    _transactionIdController = TextEditingController(
      text: inv?.transactionId ?? '',
    );

    _startDate = inv?.startDate ?? DateTime.now();
    _expectedEndDate = inv?.expectedEndDate ?? DateTime.now().add(const Duration(days: 365));
    _transactionDate = inv?.transactionDate ?? DateTime.now();
    _status = inv?.status ?? InvestmentStatus.active;
    _paymentMethod = inv?.transactionMedium ?? PaymentType.cash;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _platformController.dispose();
    _profitRateController.dispose();
    _expectedROIController.dispose();
    _notesController.dispose();
    _docLinksController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h, top: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBtn(String text, IconData icon, PaymentType method, Color primaryColor) {
    final isSelected = _paymentMethod == method;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _paymentMethod = method;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.05)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
              ),
              SizedBox(height: 4.h),
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.white38 : const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final AuthController authController = Get.find();
    final investment = Investment(
      id: widget.initialInvestment?.id ?? DateTime.now().toIso8601String(),
      title: _titleController.text.trim(),
      amountInvested: amount,
      startDate: _startDate!,
      expectedEndDate: _expectedEndDate!,
      platformName: _platformController.text.trim(),
      profitRate: _profitRateController.text.trim(),
      expectedROI: double.tryParse(_expectedROIController.text) ?? 0,
      notes: _notesController.text.trim(),
      docLinks: _docLinksController.text.trim(),
      transactionId: _transactionIdController.text.trim(),
      transactionMedium: _paymentMethod,
      transactionDate: _transactionDate!,
      status: _status,
      returns: widget.initialInvestment?.returns ?? [],
      userId: authController.user?.email ?? "unknown_user",
    );

    if (isEdit) {
      _controller.updateInvestment(investment);
    } else {
      _controller.addInvestment(investment);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color primaryColor = AppColors.primaryTeal;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Drag handle / Notch (premium feel)
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Premium top custom header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left, size: 22.sp, color: AppColors.primaryTeal),
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
                    widget.title,
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

            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),

                      // Large Amount invested at top matching Spendly standard
                      StyledAmountField(
                        controller: _amountController,
                        labelText: 'Amount Invested',
                        autofocus: !isEdit,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Required';
                          if (double.tryParse(val) == null) return 'Invalid amount';
                          return null;
                        },
                      ),

                      SizedBox(height: 28.h),

                      // Investment Title
                      StyledTextFormField(
                        controller: _titleController,
                        labelText: 'Investment Title *',
                        hintText: 'e.g. Sanchayapatra, Stock Purchase, Startup Fund',
                        prefixIcon: Icons.business_center_outlined,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),

                      // Platform Name
                      StyledTextFormField(
                        controller: _platformController,
                        labelText: 'Platform Name *',
                        hintText: 'e.g. Bangladesh Bank, LankaBangla, IDLC',
                        prefixIcon: Icons.account_balance_outlined,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),

                      // Profit Rate & Expected ROI row
                      Row(
                        children: [
                          Expanded(
                            child: StyledTextFormField(
                              controller: _profitRateController,
                              labelText: 'Profit Rate *',
                              hintText: 'e.g. 11.04% or 12–15%',
                              prefixIcon: Icons.trending_up,
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: StyledTextFormField(
                              controller: _expectedROIController,
                              labelText: 'Expected ROI (%)',
                              hintText: 'e.g. 12',
                              prefixIcon: Icons.percent_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Dates Row
                      Row(
                        children: [
                          Expanded(
                            child: StyledDatePickerButton(
                              labelText: 'Start Date *',
                              selectedDate: _startDate,
                              onDateSelected: (d) => setState(() => _startDate = d),
                              validator: (d) => d == null ? 'Required' : null,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: StyledDatePickerButton(
                              labelText: 'Expected End Date *',
                              selectedDate: _expectedEndDate,
                              onDateSelected: (d) => setState(() => _expectedEndDate = d),
                              validator: (d) => d == null ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Section Title
                      Text(
                        'TRANSACTION DETAILS',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: labelColor,
                        ),
                      ),
                      const Divider(height: 16),
                      SizedBox(height: 8.h),

                      // Payment Method Label and Selector Row
                      _buildLabel('Payment Method *', labelColor),
                      Row(
                        children: [
                          _buildPaymentBtn('Cash', Icons.payments_rounded, PaymentType.cash, primaryColor),
                          SizedBox(width: 8.w),
                          _buildPaymentBtn('MFS', Icons.phone_android_rounded, PaymentType.mfs, primaryColor),
                          SizedBox(width: 8.w),
                          _buildPaymentBtn('Card', Icons.credit_card_rounded, PaymentType.card, primaryColor),
                          SizedBox(width: 8.w),
                          _buildPaymentBtn('Transfer', Icons.account_balance_rounded, PaymentType.transfer, primaryColor),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Transaction ID
                      StyledTextFormField(
                        controller: _transactionIdController,
                        labelText: 'Transaction ID *',
                        hintText: 'e.g. TXN10023455',
                        prefixIcon: Icons.vpn_key_outlined,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),

                      // Transaction Date
                      StyledDatePickerButton(
                        labelText: 'Transaction Date *',
                        selectedDate: _transactionDate,
                        onDateSelected: (d) => setState(() => _transactionDate = d),
                        validator: (d) => d == null ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),

                      // Notes & Document Links
                      StyledTextFormField(
                        controller: _notesController,
                        labelText: 'Notes (Optional)',
                        hintText: 'Additional details or reminders...',
                        prefixIcon: Icons.notes_outlined,
                        maxLines: 2,
                      ),
                      SizedBox(height: 16.h),

                      StyledTextFormField(
                        controller: _docLinksController,
                        labelText: 'Document Link (Optional)',
                        hintText: 'e.g. drive.google.com/...',
                        prefixIcon: Icons.link_rounded,
                      ),
                      SizedBox(height: 16.h),

                      // Investment Status (if allowed/edit)
                      if (widget.allowStatusEdit || isEdit) ...[
                        StyledDropdownFormField<InvestmentStatus>(
                          value: _status,
                          labelText: 'Investment Status',
                          prefixIcon: Icons.info_outline,
                          items: InvestmentStatus.values
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.label),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _status = v!),
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Premium Emerald Action Button
                      Obx(() => ElevatedButton(
                            onPressed: _controller.isLoading.value ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 54.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 2,
                              shadowColor: AppColors.primaryTeal.withValues(alpha: 0.2),
                            ),
                            child: _controller.isLoading.value
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
                                      Icon(Icons.save_alt_rounded, size: 18.sp),
                                      SizedBox(width: 8.w),
                                      Text(
                                        isEdit ? 'Update Investment' : 'Save Investment',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          )),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
