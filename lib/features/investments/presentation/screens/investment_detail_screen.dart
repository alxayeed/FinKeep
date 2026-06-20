import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/routes/app_router.dart';

import 'package:finkeep/core/enums/payment_type.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../domain/entities/investment.dart';
import '../controller/investment_controller.dart';
import '../widgets/investment_summary_card.dart';
import '../widgets/return_details_card.dart';
import '../widgets/return_entry_item.dart';
import 'add_roi_bottom_sheet.dart';

class InvestmentDetailScreen extends StatelessWidget {
  final Investment investment;

  const InvestmentDetailScreen({
    super.key,
    required this.investment,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvestmentController>();

    return Obx(() {
      final currentInvestment = controller.investments.firstWhere(
        (i) => i.id == investment.id,
        orElse: () => investment,
      );

      return Scaffold(
        appBar: CustomAppBar(
          title: currentInvestment.title,
          showBackButton: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed(AppRoutes.updateInvestment, extra: currentInvestment);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Implement delete functionality
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 2,
            children: [
              /// Summary (title, platform, dates, status)
              InvestmentSummaryCard(investment: currentInvestment),

              /// Financials (invested, returned, profit/remaining)
              ROIDetailsCard(investment: currentInvestment),

              /// Transaction Info
              _buildTransactionInfo(currentInvestment),

              /// Returns
              _buildReturnEntries(context, currentInvestment),
            ],
          ),
        ),
      );
    });
  }

  // --------------------------------------------------
  // Transaction Info Card
  // --------------------------------------------------

  Widget _buildTransactionInfo(Investment inv) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            const Text(
              'Transaction Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            _infoRow('Transaction ID', inv.transactionId),
            _infoRow('Medium', inv.transactionMedium.displayName),
            _infoRow('Date', _fmt(inv.transactionDate)),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Return Entries Section
  // --------------------------------------------------

  Widget _buildTimelineRow({
    required int index,
    required int totalItems,
    required bool isDark,
    required Widget indicator,
    required Widget child,
  }) {
    final showTopLine = index > 0;
    final showBottomLine = index < totalItems - 1;
    final lineColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48.w,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: showTopLine ? lineColor : Colors.transparent,
                  ),
                ),
                indicator,
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: showBottomLine ? lineColor : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentOriginTile(BuildContext context, Investment inv, int totalItems, bool isDark) {
    final tileContent = Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Investment Capital Released',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  DateFormat('MMM dd, yyyy').format(inv.startDate),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Manrope',
                    color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
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

    final indicator = Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.flag_rounded,
        size: 13.sp,
        color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
      ),
    );

    return _buildTimelineRow(
      index: totalItems - 1,
      totalItems: totalItems,
      isDark: isDark,
      indicator: indicator,
      child: tileContent,
    );
  }

  Widget _buildReturnEntries(BuildContext context, Investment inv) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (context) =>
                          AddReturnBottomSheet(investmentId: inv.id),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            if (inv.returns.isEmpty) ...[
              Text(
                'No return entries yet.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              _buildInvestmentOriginTile(context, inv, 1, isDark),
            ] else ...[
              const SizedBox(height: 8),
              // Sort returns newest first to construct matching timeline top-to-bottom
              ...inv.returns.asMap().entries.map((entry) {
                final idx = entry.key;
                final ret = entry.value;
                return ReturnEntryItem(
                  investmentId: inv.id,
                  entry: ret,
                  index: idx,
                  totalItems: inv.returns.length + 1,
                );
              }),
              _buildInvestmentOriginTile(context, inv, inv.returns.length + 1, isDark),
            ],
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Helpers
  // --------------------------------------------------

  Widget _infoRow(String label, String value) {
    return Row(
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
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
