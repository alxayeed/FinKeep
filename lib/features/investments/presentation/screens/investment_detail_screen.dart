import 'package:flutter/material.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../domain/entities/investment.dart';
import '../../domain/entities/return_entry.dart';
import '../widgets/investment_summary_card.dart';
import '../widgets/return_entry_item.dart';
import '../widgets/roi_details_card.dart';
import 'add_roi_bottom_sheet.dart';

class InvestmentDetailScreen extends StatefulWidget {
  final Investment investment;
  final Function(String, ReturnEntry) onAddReturn;

  const InvestmentDetailScreen({
    super.key,
    required this.investment,
    required this.onAddReturn,
  });

  @override
  State<InvestmentDetailScreen> createState() => _InvestmentDetailScreenState();
}

class _InvestmentDetailScreenState extends State<InvestmentDetailScreen> {
  late Investment _investment;

  @override
  void initState() {
    super.initState();
    _investment = widget.investment;
  }

  void _handleAddReturn(ReturnEntry returnEntry) {
    widget.onAddReturn(_investment.id, returnEntry);
    setState(() {
      _investment.returns.add(returnEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _investment.title,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Summary (title, platform, dates, status)
            InvestmentSummaryCard(investment: _investment),
            const SizedBox(height: 16),

            /// Financials (invested, returned, profit/remaining)
            ROIDetailsCard(investment: _investment),
            const SizedBox(height: 16),

            /// Transaction Info
            _buildTransactionInfo(),
            const SizedBox(height: 16),

            /// Returns
            _buildReturnEntries(),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Transaction Info Card
  // --------------------------------------------------

  Widget _buildTransactionInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            _infoRow('Transaction ID', _investment.transactionId),
            _infoRow('Medium', _investment.transactionMedium),
            _infoRow(
              'Date',
              _fmt(_investment.transactionDate),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Return Entries Section
  // --------------------------------------------------

  Widget _buildReturnEntries() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Return Entries',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) => AddReturnBottomSheet(
                        onAddReturn: _handleAddReturn,
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            if (_investment.returns.isEmpty)
              Text(
                'No return entries yet.',
                style: TextStyle(color: Colors.grey.shade600),
              )
            else
              Column(
                children: _investment.returns
                    .map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ReturnEntryItem(entry: r),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Helpers
  // --------------------------------------------------

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
