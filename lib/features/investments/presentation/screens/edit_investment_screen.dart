import 'package:flutter/material.dart';

import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_text_form_field.dart';

class EditInvestmentScreen extends StatefulWidget {
  final Investment investment;
  final Function(Investment) onUpdate;

  const EditInvestmentScreen({
    super.key,
    required this.investment,
    required this.onUpdate,
  });

  @override
  State<EditInvestmentScreen> createState() => _EditInvestmentScreenState();
}

class _EditInvestmentScreenState extends State<EditInvestmentScreen> {
  int _currentStep = 0;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Form data
  late TextEditingController _titleController;
  late TextEditingController _amountInvestedController;
  late TextEditingController _platformNameController;
  late TextEditingController _profitRateController;
  late TextEditingController _expectedROIController;
  late TextEditingController _notesController;
  late TextEditingController _docLinksController;
  late TextEditingController _transactionIdController;
  String? _transactionMedium;
  DateTime? _startDate;
  DateTime? _expectedEndDate;
  DateTime? _transactionDate;
  InvestmentStatus? _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.investment.title);
    _amountInvestedController = TextEditingController(
        text: widget.investment.amountInvested.toString());
    _platformNameController =
        TextEditingController(text: widget.investment.platformName);
    _profitRateController =
        TextEditingController(text: widget.investment.profitRate.toString());
    _expectedROIController =
        TextEditingController(text: widget.investment.expectedROI.toString());
    _notesController = TextEditingController(text: widget.investment.notes);
    _docLinksController =
        TextEditingController(text: widget.investment.docLinks);
    _transactionIdController =
        TextEditingController(text: widget.investment.transactionId);
    _transactionMedium = widget.investment.transactionMedium;
    _startDate = widget.investment.startDate;
    _expectedEndDate = widget.investment.expectedEndDate;
    _transactionDate = widget.investment.transactionDate;
    _status = widget.investment.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Investment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.horizontal,
        onStepContinue: () {
          bool isStepValid = true;
          if (_currentStep == 0) {
            isStepValid = _formKeyStep1.currentState!.validate();
          } else if (_currentStep == 1) {
            isStepValid = _formKeyStep2.currentState!.validate();
          }

          if (isStepValid) {
            if (_currentStep < 2) {
              setState(() {
                _currentStep++;
              });
            } else {
              _updateForm();
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        steps: _buildSteps(),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Investment'),
        content: _buildStep1(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Transaction'),
        content: _buildStep2(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Review'),
        content: _buildStep3(),
        isActive: _currentStep >= 2,
      ),
    ];
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _titleController,
            labelText: 'Investment Title *',
            validator: (value) => value == null || value.isEmpty
                ? 'This field is required'
                : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _amountInvestedController,
            labelText: 'Amount Invested *',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomDatePicker(
            labelText: 'Start Date *',
            selectedDate: _startDate,
            onDateSelected: (date) => setState(() => _startDate = date),
            validator: (value) =>
                value == null ? 'This field is required' : null,
          ),
          const SizedBox(height: 16),
          CustomDatePicker(
            labelText: 'Expected End Date *',
            selectedDate: _expectedEndDate,
            onDateSelected: (date) => setState(() => _expectedEndDate = date),
            validator: (value) =>
                value == null ? 'This field is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _platformNameController,
            labelText: 'Platform Name *',
            validator: (value) => value == null || value.isEmpty
                ? 'This field is required'
                : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _profitRateController,
            labelText: 'Profit Rate (e.g., 15% or 15-17%)',
            validator: (value) => value == null || value.isEmpty
                ? 'This field is required'
                : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _expectedROIController,
            labelText: 'Expected ROI (%)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _notesController,
            labelText: 'Notes',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _docLinksController,
            labelText: 'Document Links (URL)',
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _transactionIdController,
            labelText: 'Transaction ID *',
            validator: (value) => value == null || value.isEmpty
                ? 'This field is required'
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _transactionMedium,
            decoration: const InputDecoration(
              labelText: 'Transaction Medium *',
              border: OutlineInputBorder(),
            ),
            items: ['Bank Transfer', 'bKash', 'MSF', 'Other']
                .map((medium) => DropdownMenuItem(
                      value: medium,
                      child: Text(medium),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _transactionMedium = value),
            validator: (value) =>
                value == null ? 'Please select a method' : null,
          ),
          const SizedBox(height: 16),
          CustomDatePicker(
            labelText: 'Transaction Date *',
            selectedDate: _transactionDate,
            onDateSelected: (date) => setState(() => _transactionDate = date),
            validator: (value) =>
                value == null ? 'This field is required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<InvestmentStatus>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Investment Status',
              border: OutlineInputBorder(),
            ),
            items: InvestmentStatus.values
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _status = value),
            validator: (value) =>
                value == null ? 'Please select a status' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title: ${_titleController.text}'),
        Text('Amount: \$${_amountInvestedController.text}'),
        Text('Platform: ${_platformNameController.text}'),
        // Add other fields for review
        const SizedBox(height: 20),
        const Text('Please review your details before updating.'),
      ],
    );
  }

  void _updateForm() {
    if (_formKeyStep1.currentState!.validate() &&
        _formKeyStep2.currentState!.validate()) {
      if (_startDate == null ||
          _expectedEndDate == null ||
          _transactionDate == null ||
          _transactionMedium == null ||
          _status == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }
      final updatedInvestment = Investment(
        id: widget.investment.id,
        title: _titleController.text,
        amountInvested: double.parse(_amountInvestedController.text),
        startDate: _startDate!,
        expectedEndDate: _expectedEndDate!,
        platformName: _platformNameController.text,
        profitRate: _profitRateController.text,
        expectedROI: double.tryParse(_expectedROIController.text) ?? 0.0,
        notes: _notesController.text,
        docLinks: _docLinksController.text,
        transactionId: _transactionIdController.text,
        transactionMedium: _transactionMedium!,
        transactionDate: _transactionDate!,
        status: _status!,
        returns: widget.investment.returns,
      );
      widget.onUpdate(updatedInvestment);
      Navigator.of(context).pop();
    }
  }
}
