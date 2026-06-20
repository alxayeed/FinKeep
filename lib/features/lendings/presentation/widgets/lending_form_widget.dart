import 'package:flutter/material.dart';
import 'package:finkeep/core/common/widgets/widgets.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/enums/payment_type.dart';

import '../../domain/entity/lending/lending_entity.dart';

class LendingFormWidget extends StatefulWidget {
  final LendingEntity? initialLending;
  final String submitButtonText;
  final bool isLoading;
  final void Function(
    double amount,
    String personName,
    String contact,
    LendingType type,
    LendingStatus status,
    DateTime createdDate,
    DateTime? dueDate,
    String? description,
    PaymentType paymentMethod,
  ) onSubmit;

  const LendingFormWidget({
    super.key,
    this.initialLending,
    required this.submitButtonText,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<LendingFormWidget> createState() => _LendingFormWidgetState();
}

class _LendingFormWidgetState extends State<LendingFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final personNameController = TextEditingController();
  final personContactController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  // 0 = Given, 1 = Taken
  int _selectedType = 0;
  LendingStatus _selectedStatus = LendingStatus.due;
  DateTime _transactionDate = DateTime.now();
  DateTime? _dueDate;
  late PaymentType _paymentMethod;

  final Map<LendingStatus, String> _statusLabels = {
    LendingStatus.due: 'Due / Unpaid',
    LendingStatus.partial: 'Partial Repayment',
    LendingStatus.overdue: 'Overdue',
    LendingStatus.paid: 'Fully Repaid',
  };

  @override
  void initState() {
    super.initState();
    final l = widget.initialLending;
    if (l != null) {
      amountController.text = l.amount.toStringAsFixed(0);
      personNameController.text = l.person.name;
      personContactController.text = l.person.contactNumber ?? '';
      descriptionController.text = l.description ?? '';
      _selectedType = l.type == LendingType.given ? 0 : 1;
      _selectedStatus = l.status;
      _transactionDate = l.createdDate;
      _dueDate = l.dueDate;
      _paymentMethod = l.paymentMethod;
    } else {
      _paymentMethod = PaymentType.cash;
    }
  }

  @override
  void dispose() {
    personNameController.dispose();
    personContactController.dispose();
    amountController.dispose();
    descriptionController.dispose();
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

  Widget _typeTab(String label, int index, bool isDark) {
    final isActive = _selectedType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (widget.initialLending == null) {
            setState(() => _selectedType = index);
          }
        },
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (personNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the person\'s name.'), backgroundColor: AppColors.error),
      );
      return;
    }

    widget.onSubmit(
      parsedAmount,
      personNameController.text.trim(),
      personContactController.text.trim(),
      _selectedType == 0 ? LendingType.given : LendingType.taken,
      _selectedStatus,
      _transactionDate,
      _dueDate,
      descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
      _paymentMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color primaryColor = AppColors.primaryTeal;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // ── Given / Taken toggle ──
          Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
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
            autofocus: widget.initialLending == null,
          ),

          SizedBox(height: 28.h),

          // ── Person Name ──
          StyledTextFormField(
            controller: personNameController,
            labelText: 'Person Name',
            hintText: 'Who is this record for?',
            prefixIcon: Icons.person_outline_rounded,
            readOnly: widget.initialLending != null,
          ),

          SizedBox(height: 12.h),

          // ── Contact ──
          StyledTextFormField(
            controller: personContactController,
            labelText: 'Contact Number',
            hintText: '+880 1XXX-XXXXXX',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            readOnly: widget.initialLending != null,
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
                  onDateSelected: (date) => setState(() => _dueDate = date),
                  isOptional: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Payment Method Label and Selector Row ──
          _buildLabel('Payment Method', labelColor),
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
            onPressed: widget.isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 54.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 2,
              shadowColor: primaryColor.withValues(alpha: 0.2),
            ),
            child: widget.isLoading
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
                        widget.submitButtonText,
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
      ),
    );
  }
}
