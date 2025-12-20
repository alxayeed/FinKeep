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
            Row(
              children: [
                Expanded(
                  child: Text(
                    investment.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _statusChip(),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.account_balance,
                    size: 16, color: Colors.grey.shade600),
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
            ),
            if (investment.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${investment.notes}',
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ],
            if (investment.docLinks.isNotEmpty) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.tryParse(investment.docLinks);
                  if (uri != null) {
                    try {
                      final launched = await launchUrl(
                        uri,
                        mode: LaunchMode.inAppWebView,
                      );
                      if (!launched) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Could not launch the link')),
                        );
                      }
                    } catch (e) {
                      log(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid URL - ${e}')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid URL15')),
                    );
                  }
                },
                child: Text(
                  investment.docLinks,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip() {
    final statusData = _statusConfig(investment.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusData.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusData.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: statusData.color,
        ),
      ),
    );
  }

  _StatusConfig _statusConfig(InvestmentStatus status) {
    switch (status) {
      case InvestmentStatus.active:
        return _StatusConfig('Active', Colors.blue);
      case InvestmentStatus.returnsStarted:
        return _StatusConfig('Returns Started', Colors.orange);
      case InvestmentStatus.completed:
        return _StatusConfig('Completed', Colors.green);
      case InvestmentStatus.loss:
        return _StatusConfig('Loss', Colors.red);
    }
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _StatusConfig {
  final String label;
  final Color color;

  const _StatusConfig(this.label, this.color);
}
