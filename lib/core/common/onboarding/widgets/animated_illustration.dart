import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

class AnimatedIllustration extends StatefulWidget {
  final int index;
  final bool isActive;

  const AnimatedIllustration({
    required this.index,
    required this.isActive,
    super.key,
  });

  @override
  State<AnimatedIllustration> createState() => _AnimatedIllustrationState();
}

class _AnimatedIllustrationState extends State<AnimatedIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _bobbingController;
  late final AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _bobbingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (widget.isActive) {
      _entryController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _entryController.forward(from: 0.0);
      } else {
        _entryController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _bobbingController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextCol = isDark ? Colors.white60 : const Color(0xFF64748B);

    return AnimatedBuilder(
      animation: Listenable.merge([_bobbingController, _entryController]),
      builder: (context, child) {
        final double bob = math.sin(_bobbingController.value * 2 * math.pi) * 8.0;
        final double entry = _entryController.value;

        switch (widget.index) {
          case 0:
            return _buildExpenseIllustration(cardBg, borderCol, textCol, subTextCol, bob, entry);
          case 1:
            return _buildLendingIllustration(cardBg, borderCol, textCol, subTextCol, bob, entry);
          case 2:
            return _buildInvestmentIllustration(cardBg, borderCol, textCol, subTextCol, bob, entry, isDark);
          case 3:
            return _buildSecurityIllustration(cardBg, borderCol, textCol, subTextCol, bob, entry);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildExpenseIllustration(
    Color cardBg,
    Color borderCol,
    Color textCol,
    Color subTextCol,
    double bob,
    double entry,
  ) {
    return Transform.scale(
      scale: 0.9 + (0.1 * entry),
      child: Opacity(
        opacity: entry,
        child: SizedBox(
          width: 250.w,
          height: 350.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Main phone mockup/dashboard card
              Transform.translate(
                offset: Offset(0, bob * 0.4),
                child: Container(
                  width: 210.w,
                  height: 310.h,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: borderCol, width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(Icons.wallet, color: AppColors.primaryTeal, size: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FinKeep',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: textCol,
                                ),
                              ),
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 8.sp,
                                  color: subTextCol,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Summary box
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SPENT VS BUDGET',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryTeal,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '31,650 ৳',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: textCol,
                                  ),
                                ),
                                Text(
                                  'Usage: 70%',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w600,
                                    color: subTextCol,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: 0.7,
                                color: AppColors.primaryTeal,
                                backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                                minHeight: 6.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Transaction Items Mockup
                      Text(
                        'SPENDING BY CATEGORY',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w800,
                          color: subTextCol,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildMiniCategoryRow('Food', '7,500 ৳', Colors.orange, 0.45, textCol),
                      SizedBox(height: 6.h),
                      _buildMiniCategoryRow('Utilities', '5,200 ৳', Colors.amber, 0.35, textCol),
                      SizedBox(height: 6.h),
                      _buildMiniCategoryRow('Transport', '3,850 ৳', Colors.blue, 0.25, textCol),
                    ],
                  ),
                ),
              ),

              // Decorative Floating Badge 1: Top-Right Sparkle Chip
              Positioned(
                top: -5.h + bob * 0.8,
                right: 5.w,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13EC5B),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF13EC5B).withValues(alpha: 0.3),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 18.sp),
                ),
              ),

              // Decorative Floating Badge 2: Bottom-Left Bill Circle
              Positioned(
                bottom: 5.h - bob * 0.6,
                left: 5.w,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderCol, width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(Icons.payments_outlined, color: AppColors.primaryTeal, size: 18.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniCategoryRow(
    String label,
    String amount,
    Color color,
    double progress,
    Color textCol,
  ) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: textCol,
                    ),
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                      color: textCol,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: progress,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.1),
                  minHeight: 3.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLendingIllustration(
    Color cardBg,
    Color borderCol,
    Color textCol,
    Color subTextCol,
    double bob,
    double entry,
  ) {
    return Transform.scale(
      scale: 0.9 + (0.1 * entry),
      child: Opacity(
        opacity: entry,
        child: SizedBox(
          width: 250.w,
          height: 350.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Main Lending Card representation
              Transform.translate(
                offset: Offset(0, bob * 0.4),
                child: Container(
                  width: 210.w,
                  height: 310.h,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: borderCol, width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: Colors.purple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(Icons.handshake_outlined, color: Colors.purple, size: 14.sp),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Lendings',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: textCol,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Lending Mock Item 1
                      _buildMiniLendingCard(
                        'Tariq Ahmad',
                        'LENT',
                        '10,000 ৳',
                        AppColors.success,
                        cardBg,
                        borderCol,
                        textCol,
                        subTextCol,
                        1.0,
                      ),
                      SizedBox(height: 12.h),
                      // Lending Mock Item 2
                      _buildMiniLendingCard(
                        'Rashed Karim',
                        'BORROWED',
                        '20,000 ৳',
                        AppColors.error,
                        cardBg,
                        borderCol,
                        textCol,
                        subTextCol,
                        0.85,
                      ),
                    ],
                  ),
                ),
              ),

              // Decorative Floating Badge: Top-Right Handshake Circle
              Positioned(
                top: 20.h + bob * 0.7,
                right: -2.w,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.25),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(Icons.done_all_rounded, color: Colors.white, size: 18.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniLendingCard(
    String name,
    String tag,
    String amount,
    Color tagColor,
    Color bg,
    Color border,
    Color textCol,
    Color subTextCol,
    double slideScale,
  ) {
    return Transform.translate(
      offset: Offset((1.0 - slideScale) * -20.w, 0),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: border, width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: tagColor.withValues(alpha: 0.1),
                      child: Text(
                        name.substring(0, 1),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: tagColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: textCol,
                          ),
                        ),
                        Text(
                          'Jun 20, 2026',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 7.sp,
                            color: subTextCol,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 6.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 8.sp,
                    color: subTextCol,
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: textCol,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentIllustration(
    Color cardBg,
    Color borderCol,
    Color textCol,
    Color subTextCol,
    double bob,
    double entry,
    bool isDark,
  ) {
    return Transform.scale(
      scale: 0.9 + (0.1 * entry),
      child: Opacity(
        opacity: entry,
        child: Transform.translate(
          offset: Offset(0, bob * 0.4),
          child: Container(
            width: 210.w,
            height: 310.h,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: borderCol, width: 1.5.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.trending_up, color: Colors.orange, size: 14.sp),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Investments',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: textCol,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Chart Box
                Row(
                  children: [
                    // Circular Sweep Chart Representation
                    SizedBox(
                      width: 80.w,
                      height: 80.h,
                      child: CustomPaint(
                        painter: _ChartPainter(
                          sweepAngle: entry * 2 * math.pi * 0.75,
                          isDark: isDark,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '3',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: textCol,
                                  height: 1,
                                ),
                              ),
                              Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 6.sp,
                                  fontWeight: FontWeight.bold,
                                  color: subTextCol,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Legend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendRow('Active', '1', Colors.blue, textCol),
                          SizedBox(height: 4.h),
                          _buildLegendRow('Returns Started', '1', Colors.orange, textCol),
                          SizedBox(height: 4.h),
                          _buildLegendRow('Completed', '1', Colors.green, textCol),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Divider
                Container(
                  height: 1.h,
                  color: borderCol,
                ),
                SizedBox(height: 16.h),
                // Summary Block
                Text(
                  'OVERALL SUMMARY',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w800,
                    color: subTextCol,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildSummaryTextRow('TOTAL INVESTED', '2,05,000 ৳', textCol, subTextCol),
                SizedBox(height: 8.h),
                _buildSummaryTextRow('TOTAL RECEIVED', '31,100 ৳', AppColors.primaryTeal, subTextCol),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendRow(String label, String count, Color color, Color textCol) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 8.sp,
              color: textCol,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          count,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
            color: textCol,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryTextRow(String label, String value, Color valueColor, Color subTextCol) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 7.sp,
            fontWeight: FontWeight.bold,
            color: subTextCol,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityIllustration(
    Color cardBg,
    Color borderCol,
    Color textCol,
    Color subTextCol,
    double bob,
    double entry,
  ) {
    return Transform.scale(
      scale: 0.9 + (0.1 * entry),
      child: Opacity(
        opacity: entry,
        child: SizedBox(
          width: 250.w,
          height: 250.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Privacy/Security Card (Top-Left)
              Positioned(
                left: 15.w,
                top: 20.h + bob * 0.4,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: cardBg.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: borderCol, width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_rounded,
                        color: AppColors.primaryTeal,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // Floating Lock Badge for Privacy Card
              Positioned(
                top: 10.h + bob * 0.6,
                left: 105.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13EC5B),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF13EC5B).withValues(alpha: 0.3),
                        blurRadius: 10.r,
                        offset: Offset(0, 3.h),
                      ),
                    ],
                  ),
                  child: Icon(Icons.lock_rounded, color: Colors.white, size: 16.sp),
                ),
              ),

              // 2. Offline Card (Bottom-Right)
              Positioned(
                right: 15.w,
                bottom: 20.h - bob * 0.4,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: cardBg.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: borderCol, width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_off_rounded,
                        color: Colors.blue,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // Floating Local Storage Badge for Offline Card
              Positioned(
                bottom: 10.h - bob * 0.6,
                right: 105.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 10.r,
                        offset: Offset(0, 3.h),
                      ),
                    ],
                  ),
                  child: Icon(Icons.storage_rounded, color: Colors.white, size: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Chart painter for investments slide
class _ChartPainter extends CustomPainter {
  final double sweepAngle;
  final bool isDark;

  _ChartPainter({required this.sweepAngle, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.w;
    final Rect rect = Offset(strokeWidth / 2, strokeWidth / 2) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    // Track
    final Paint trackPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, 2 * math.pi, false, trackPaint);

    // Sweep segments (split into colors representing legend items)
    final double activeFraction = 0.33;
    final double returnsFraction = 0.33;
    final double completedFraction = 0.34;

    final Paint activePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Paint returnsPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Paint completedPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    double startAngle = -math.pi / 2;

    // Active
    final double sweepActive = sweepAngle * activeFraction;
    if (sweepActive > 0) {
      canvas.drawArc(rect, startAngle, sweepActive, false, activePaint);
      startAngle += sweepActive;
    }

    // Returns
    final double sweepReturns = sweepAngle * returnsFraction;
    if (sweepReturns > 0) {
      canvas.drawArc(rect, startAngle, sweepReturns, false, returnsPaint);
      startAngle += sweepReturns;
    }

    // Completed
    final double sweepCompleted = sweepAngle * completedFraction;
    if (sweepCompleted > 0) {
      canvas.drawArc(rect, startAngle, sweepCompleted, false, completedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle || oldDelegate.isDark != isDark;
  }
}
