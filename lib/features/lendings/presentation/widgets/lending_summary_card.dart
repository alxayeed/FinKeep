import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/core/extensions/double_ext.dart';

class LendingSummaryCard extends StatelessWidget {
  final double totalAmount;
  final double totalRepaid;
  final double totalDue;
  final bool isGiven;

  const LendingSummaryCard({
    super.key,
    required this.totalAmount,
    required this.totalRepaid,
    required this.totalDue,
    required this.isGiven,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Curated color themes based on Given vs Taken
    final cardBg = isGiven
        ? (isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5))
        : (isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF)); // Dark indigo vs Light indigo for Taken
    final cardBorder = isGiven
        ? (isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0))
        : (isDark ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE));
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final accentTextColor = isGiven
        ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46))
        : (isDark ? const Color(0xFF818CF8) : const Color(0xFF3730A3));
    final iconColor = isGiven
        ? (isDark ? const Color(0xFF34D399) : const Color(0xFF059669))
        : (isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5));

    final labelTotal = isGiven ? 'TOTAL GIVEN' : 'TOTAL TAKEN';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Outstanding/Due Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL DUE',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: accentTextColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          totalDue.toCurrency(),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: FaIcon(
                            context.currency.icon,
                            size: 18.sp,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: isGiven
                        ? (isDark ? const Color(0xFF047857) : const Color(0xFFD1FAE5))
                        : (isDark ? const Color(0xFF312E81) : const Color(0xFFE0E7FF)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    isGiven ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                    color: iconColor,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 10.h),
            
            // Divider line
            Container(
              height: 1,
              color: cardBorder.withValues(alpha: 0.3),
            ),
            
            SizedBox(height: 10.h),
            
            // Row 2: Secondary info (Total Given/Taken and Total Repaid)
            Row(
              children: [
                // Total Given/Taken
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labelTotal,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white38 : const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                       SizedBox(height: 2.h),
                       Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.currency.symbol,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white30 : const Color(0xFFCBD5E1),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            totalAmount.toCurrency(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Total Repaid / Paid Back
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL REPAID',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white38 : const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.currency.symbol,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white30 : const Color(0xFFCBD5E1),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            totalRepaid.toCurrency(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LendingSummaryShimmer extends StatelessWidget {
  const LendingSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color baseColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final Color highlightColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFF1F5F9);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: 110.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }
}
