import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/lending_person_entity.dart';
import '../controllers/lendings_controller.dart';

class UpdateLendingScreen extends StatefulWidget {
  final LendingEntity lending;

  const UpdateLendingScreen({super.key, required this.lending});

  @override
  State<UpdateLendingScreen> createState() => _UpdateLendingScreenState();
}

class _UpdateLendingScreenState extends State<UpdateLendingScreen> {
  final _formKey = GlobalKey<FormState>();
  final LendingsController controller = Get.find<LendingsController>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  LendingType? _selectedType;
  LendingStatus? _selectedStatus;
  LendingPersonEntity? _selectedPerson;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    controller.fetchUserPersons(); // load persons

    final l = widget.lending;
    _amountController.text = l.amount.toString();
    _descriptionController.text = l.description ?? '';
    _selectedType = l.type;
    _selectedStatus = l.status;
    _selectedPerson =
        controller.personsList.firstWhereOrNull((p) => p.id == l.person.id);
    _dueDate = l.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Lending'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return controller.personsList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Person
                      DropdownButtonFormField<LendingPersonEntity>(
                        initialValue: _selectedPerson,
                        items: controller.personsList
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.name),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Person',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) =>
                            setState(() => _selectedPerson = val),
                        validator: (val) =>
                            val == null ? 'Please select a person' : null,
                      ),
                      const SizedBox(height: 16),

                      // Amount
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter amount';
                          if (double.tryParse(val) == null)
                            return 'Invalid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Type
                      DropdownButtonFormField<LendingType>(
                        initialValue: _selectedType,
                        items: LendingType.values
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t.name.capitalizeFirst ?? t.name),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => setState(() => _selectedType = val),
                        validator: (val) => val == null ? 'Select type' : null,
                      ),
                      const SizedBox(height: 16),

                      // Status
                      DropdownButtonFormField<LendingStatus>(
                        initialValue: _selectedStatus,
                        items: LendingStatus.values
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s.name.capitalizeFirst ?? s.name),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) =>
                            setState(() => _selectedStatus = val),
                        validator: (val) =>
                            val == null ? 'Select status' : null,
                      ),
                      const SizedBox(height: 16),

                      // Due Date
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: const OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today,
                              color: AppColors.primaryTeal),
                        ),
                        controller: TextEditingController(
                            text: _dueDate != null
                                ? dateFormat.format(_dueDate!)
                                : ''),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _dueDate = picked);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Update Lending'),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPerson == null ||
        _selectedType == null ||
        _selectedStatus == null) return;

    final updated = LendingEntity(
      id: widget.lending.id,
      person: _selectedPerson!,
      amount: double.parse(_amountController.text),
      type: _selectedType!,
      status: _selectedStatus!,
      description: _descriptionController.text,
      createdDate: widget.lending.createdDate,
      dueDate: _dueDate,
      userId: widget.lending.userId,
      repayments: widget.lending.repayments,
    );

    Get.back(result: updated);
  }
}
