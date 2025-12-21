import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';

class InvestmentSummaryCard extends StatelessWidget {
  final Investment investment;

  const InvestmentSummaryCard({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerRow(),
            const SizedBox(height: 8),
            _platformAndDatesRow(),
            if (investment.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              _notesWidget(),
            ],
            if (investment.docLinks.isNotEmpty) ...[
              const SizedBox(height: 8),
              _documentLink(context),
            ],
            const SizedBox(height: 8),
            _durationWidget(),
          ],
        ),
      ),
    );
  }

  // ---------------- Header ----------------
  Widget _headerRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            investment.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        _statusChip(),
      ],
    );
  }

  // ---------------- Platform & Dates ----------------
  Widget _platformAndDatesRow() {
    return Row(
      children: [
        Icon(Icons.account_balance, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          investment.platformName,
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const Spacer(),
        Text(
          '${_fmt(investment.startDate)} - ${_fmt(investment.expectedEndDate)}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ---------------- Notes ----------------
  Widget _notesWidget() {
    return Text(
      'Notes: ${investment.notes}',
      style: TextStyle(color: Colors.grey.shade800),
    );
  }

  // ---------------- Document Link ----------------
  Widget _documentLink(BuildContext context) {
    return GestureDetector(
      onTap: () => _previewDocument(context),
      child: Text(
        investment.docLinks,
        style: TextStyle(
          color: Colors.blue.shade700,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _previewDocument(BuildContext context) async {
    final uri = Uri.tryParse(investment.docLinks);
    if (uri == null) {
      _showSnack(context, 'Invalid URL');
      return;
    }

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
      if (!launched) _showSnack(context, 'Could not launch the link');
    } catch (e) {
      log(e.toString());
      _showSnack(context, 'Invalid URL - $e');
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------------- Duration ----------------
  Widget _durationWidget() {
    final duration = investment.expectedEndDate.difference(
      investment.startDate,
    );
    final months = duration.inDays ~/ 30;
    final days = duration.inDays % 30;

    return Row(
      children: [
        const Icon(Icons.timelapse, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          'Duration: ${months > 0 ? '$months month${months > 1 ? 's' : ''}' : ''} '
          '${days > 0 ? '$days day${days > 1 ? 's' : ''}' : ''}',
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  // ---------------- Status Chip ----------------
  Widget _statusChip() {
    final status = investment.status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: status.color,
        ),
      ),
    );
  }

  // ---------------- Helpers ----------------
  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
