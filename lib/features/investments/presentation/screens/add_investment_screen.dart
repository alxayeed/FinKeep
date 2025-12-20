import 'package:flutter/material.dart';

import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_text_form_field.dart';

class AddInvestmentScreen extends StatefulWidget {
  final Function(Investment) onSubmit;

  const AddInvestmentScreen({super.key, required this.onSubmit});

  @override
  State<AddInvestmentScreen> createState() => _AddInvestmentScreenState();
}

class _AddInvestmentScreenState extends State<AddInvestmentScreen> {
  int _currentStep = 0;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Form data
  final _titleController = TextEditingController();
  final _amountInvestedController = TextEditingController();
  final _platformNameController = TextEditingController();
  final _profitRateController = TextEditingController();
  final _expectedROIController = TextEditingController();
  final _notesController = TextEditingController();
  final _docLinksController = TextEditingController();
  final _transactionIdController = TextEditingController();
  String? _transactionMedium;
  DateTime? _startDate;
  DateTime? _expectedEndDate;
  DateTime? _transactionDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Investment'),
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
              _submitForm();
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
          ),
          const SizedBox(height: 16),
          CustomDatePicker(
            labelText: 'Expected End Date *',
            selectedDate: _expectedEndDate,
            onDateSelected: (date) => setState(() => _expectedEndDate = date),
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
            value: _transactionMedium,
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
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    // A simple review widget. In a real app, this would be more detailed.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title: ${_titleController.text}'),
        Text('Amount: \$${_amountInvestedController.text}'),
        Text('Platform: ${_platformNameController.text}'),
        // Add other fields for review
        const SizedBox(height: 20),
        const Text('Please review your details before submitting.'),
      ],
    );
  }

  void _submitForm() {
    // Final validation
    if (_formKeyStep1.currentState!.validate() &&
        _formKeyStep2.currentState!.validate()) {
      final newInvestment = Investment(
        id: DateTime.now().toString(),
        // Simple unique ID
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
        status: InvestmentStatus.active,
        returns: [],
      );
      widget.onSubmit(newInvestment);
      Navigator.of(context).pop();
    }
  }
}
