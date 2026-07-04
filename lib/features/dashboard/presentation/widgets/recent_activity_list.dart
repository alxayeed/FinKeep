import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../../income/presentation/controllers/income_category_controller.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../domain/entities/dashboard_recent_activity_entity.dart';

class RecentActivityList extends StatelessWidget {
  final List<DashboardRecentActivityEntity> activities;

  const RecentActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final symbol = context.currency.symbol;
    final IncomeCategoryController incomeCategoryController = Get.find();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'RECENT ACTIVITIES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline,
                      color: AppColors.grey,
                      size: 16,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _showRecentActivitiesInfo(context),
                  ),
                ],
              ),
              if (activities.isNotEmpty)
                Text(
                  'Last ${activities.length}',
                  style: const TextStyle(fontSize: 10, color: AppColors.grey),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (activities.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No recent activities recorded',
                  style: TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => Divider(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                height: 16,
              ),
              itemBuilder: (context, index) {
                final activity = activities[index];
                final formattedDate = DateFormat('MMM d, h:mm a').format(activity.date);

                // Resolve Income category label
                String resolvedCategory = activity.category;
                if (activity.type == 'income') {
                  final cat = incomeCategoryController.categories
                      .firstWhereOrNull((c) => c.id == activity.category);
                  if (cat != null) {
                    resolvedCategory = cat.displayLabel;
                  }
                }

                // Visual details based on transaction type
                Color typeColor;
                FaIconData icon;
                String prefix;
                switch (activity.type) {
                  case 'income':
                    typeColor = AppColors.success;
                    icon = FontAwesomeIcons.circleArrowUp;
                    prefix = '+';
                    break;
                  case 'expense':
                    typeColor = AppColors.error;
                    icon = FontAwesomeIcons.circleArrowDown;
                    prefix = '-';
                    break;
                  case 'lending':
                    typeColor = Colors.orange;
                    icon = FontAwesomeIcons.handshake;
                    prefix = '';
                    break;
                  default:
                    typeColor = Colors.teal;
                    icon = FontAwesomeIcons.wallet;
                    prefix = '';
                }

                return Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: FaIcon(icon, color: typeColor, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.cardTitle(context).copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$resolvedCategory • $formattedDate',
                            style: AppTextStyles.cardSubtitle(context).copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$prefix${activity.amount.toCurrency()} $symbol',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  void _showRecentActivitiesInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activities Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'A consolidated chronological feed showing your 8 most recent financial actions across all features.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This includes newly added or modified incomes, expenses, repayments, and lendings/borrowings within the selected timeframe. It is a quick snapshot to help verify your latest logging activity.',
                  style: TextStyle(fontSize: 13, color: AppColors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RecentActivityListShimmer extends StatelessWidget {
  const RecentActivityListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final itemBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 14,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 60,
                            height: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
