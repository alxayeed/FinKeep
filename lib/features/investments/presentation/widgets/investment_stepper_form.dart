import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/styled_dropdown_form_field.dart';
import '../../../../core/common/widgets/styled_text_form_field.dart';
import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';
import '../controller/investment_controller.dart';
import '../widgets/custom_date_picker.dart';

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
  int _currentStep = 0;

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _platformController;
  late final TextEditingController _profitRateController;
  late final TextEditingController _expectedROIController;
  late final TextEditingController _notesController;
  late final TextEditingController _docLinksController;
  late final TextEditingController _transactionIdController;
  late final TextEditingController _transactionMediumController;

  DateTime? _startDate;
  DateTime? _expectedEndDate;
  DateTime? _transactionDate;
  InvestmentStatus _status = InvestmentStatus.active;

  bool get isEdit => widget.initialInvestment != null;

  final InvestmentController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    final inv = widget.initialInvestment;

    _titleController = TextEditingController(text: inv?.title ?? '');
    _amountController = TextEditingController(
      text: inv?.amountInvested.toString() ?? '',
    );
    _platformController = TextEditingController(text: inv?.platformName ?? '');
    _profitRateController = TextEditingController(text: inv?.profitRate ?? '');
    _expectedROIController = TextEditingController(
      text: inv?.expectedROI.toString() ?? '',
    );
    _notesController = TextEditingController(text: inv?.notes ?? '');
    _docLinksController = TextEditingController(text: inv?.docLinks ?? '');
    _transactionIdController = TextEditingController(
      text: inv?.transactionId ?? '',
    );
    _transactionMediumController = TextEditingController(
      text: inv?.transactionMedium ?? '',
    );

    _startDate = inv?.startDate;
    _expectedEndDate = inv?.expectedEndDate;
    _transactionDate = inv?.transactionDate;
    _status = inv?.status ?? InvestmentStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        steps: [
          Step(
            title: const Text('Investment'),
            content: _stepInvestment(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Transaction'),
            content: _stepTransaction(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Review'),
            content: _stepReview(),
            isActive: _currentStep >= 2,
          ),
        ],
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == 2;
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (_currentStep == 0) {
                      Navigator.pop(context);
                    } else {
                      setState(() => _currentStep--);
                    }
                  },
                  child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final valid = _currentStep == 0
                        ? _formKeyStep1.currentState!.validate()
                        : _currentStep == 1
                        ? _formKeyStep2.currentState!.validate()
                        : true;

                    if (!valid) return;

                    if (isLastStep) {
                      _submit();
                    } else {
                      setState(() => _currentStep++);
                    }
                  },
                  child: Text(isLastStep ? 'Save' : 'Next'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- Step 1 ----------------
  Widget _stepInvestment() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledTextFormField(
            controller: _titleController,
            labelText: 'Investment Title *',
            validator: _required,
          ),
          const SizedBox(height: 12),
          StyledTextFormField(
            controller: _amountController,
            labelText: 'Amount Invested *',
            keyboardType: TextInputType.number,
            validator: _requiredAmount,
          ),
          const SizedBox(height: 12),
          CustomDatePicker(
            labelText: 'Start Date *',
            selectedDate: _startDate,
            onDateSelected: (d) => _startDate = d,
            validator: _requiredDate,
          ),
          const SizedBox(height: 12),
          CustomDatePicker(
            labelText: 'Expected End Date *',
            selectedDate: _expectedEndDate,
            onDateSelected: (d) => _expectedEndDate = d,
            validator: _requiredDate,
          ),
          const SizedBox(height: 12),
          StyledTextFormField(
            controller: _platformController,
            labelText: 'Platform Name *',
            validator: _required,
          ),
          const SizedBox(height: 12),
          StyledTextFormField(
            controller: _profitRateController,
            labelText: 'Profit Rate (e.g. 15% / 15–17%) *',
            validator: _required,
          ),
          const SizedBox(height: 12),
          StyledTextFormField(
            controller: _expectedROIController,
            labelText: 'Expected ROI (%)',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // ---------------- Step 2 ----------------
  Widget _stepTransaction() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledTextFormField(
            controller: _transactionMediumController,
            labelText: 'Transaction Medium *',
            validator: _required,
          ),
          const SizedBox(height: 12),
          StyledTextFormField(
            controller: _transactionIdController,
            labelText: 'Transaction ID *',
            validator: _required,
          ),
          const SizedBox(height: 12),
          CustomDatePicker(
            labelText: 'Transaction Date *',
            selectedDate: _transactionDate,
            onDateSelected: (d) => _transactionDate = d,
            validator: _requiredDate,
          ),
          const SizedBox(height: 12),
          StyledTextFormField(
            controller: _notesController,
            labelText: 'Notes',
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          StyledTextFormField(
            controller: _docLinksController,
            labelText: 'Document Link',
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),
          if (widget.allowStatusEdit)
            StyledDropdownFormField<InvestmentStatus>(
              value: _status,
              labelText: 'Investment Status',
              items: InvestmentStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => _status = v!),
            ),
        ],
      ),
    );
  }

  // ---------------- Step 3 ----------------
  Widget _stepReview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reviewSection(
            title: 'Investment Details',
            children: [
              _reviewRow('Title', _titleController.text),
              _reviewRow('Amount Invested', '৳${_amountController.text}'),
              _reviewRow(
                'Start Date',
                _startDate != null ? _formatDate(_startDate!) : '-',
              ),
              _reviewRow(
                'Expected End Date',
                _expectedEndDate != null ? _formatDate(_expectedEndDate!) : '-',
              ),
              _reviewRow('Platform Name', _platformController.text),
              _reviewRow('Profit Rate', _profitRateController.text),
              _reviewRow(
                'Expected ROI',
                _expectedROIController.text.isNotEmpty
                    ? '${_expectedROIController.text}%'
                    : '-',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _reviewSection(
            title: 'Transaction Details',
            children: [
              _reviewRow(
                'Transaction Medium',
                _transactionMediumController.text,
              ),
              _reviewRow('Transaction ID', _transactionIdController.text),
              _reviewRow(
                'Transaction Date',
                _transactionDate != null ? _formatDate(_transactionDate!) : '-',
              ),
              _reviewRow(
                'Notes',
                _notesController.text.isNotEmpty ? _notesController.text : '-',
              ),
              _reviewRow(
                'Document Link',
                _docLinksController.text.isNotEmpty
                    ? _docLinksController.text
                    : '-',
              ),
              if (widget.allowStatusEdit) _reviewRow('Status', _status.name),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Please review all details carefully before submitting.',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ---------------- Submit ----------------
  void _submit() {
    final investment = Investment(
      id: widget.initialInvestment?.id ?? DateTime.now().toIso8601String(),
      title: _titleController.text,
      amountInvested: double.parse(_amountController.text),
      startDate: _startDate!,
      expectedEndDate: _expectedEndDate!,
      platformName: _platformController.text,
      profitRate: _profitRateController.text,
      expectedROI: double.tryParse(_expectedROIController.text) ?? 0,
      notes: _notesController.text,
      docLinks: _docLinksController.text,
      transactionId: _transactionIdController.text,
      transactionMedium: _transactionMediumController.text,
      transactionDate: _transactionDate!,
      status: _status,
      returns: widget.initialInvestment?.returns ?? [],
    );

    if (isEdit) {
      _controller.updateInvestment(investment);
    } else {
      _controller.addInvestment(investment);
    }

    Navigator.pop(context);
  }

  // ---------------- Validators ----------------
  String? _required(String? val) =>
      val == null || val.isEmpty ? 'Required' : null;

  String? _requiredAmount(String? val) {
    if (val == null || val.isEmpty) return 'Required';
    return double.tryParse(val) == null ? 'Invalid amount' : null;
  }

  String? _requiredDate(DateTime? val) => val == null ? 'Required' : null;

  // ---------------- Review Helpers ----------------
  Widget _reviewSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
