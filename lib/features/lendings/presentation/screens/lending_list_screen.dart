import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/common/widgets/custom_app_bar.dart';
import 'package:spendly/core/common/widgets/custom_fab.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_list_item.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_shimmer_list.dart';

import '../../domain/entity/lending/lending_entity.dart';

class LendingListScreen extends StatefulWidget {
  const LendingListScreen({super.key});

  @override
  State<LendingListScreen> createState() => _LendingListScreenState();
}

class _LendingListScreenState extends State<LendingListScreen> {
  final LendingsController controller = Get.find();
  final TextEditingController _searchController = TextEditingController();

  // 0 = Given, 1 = Taken
  int _selectedTab = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LendingEntity> get _filteredLendings {
    final type = _selectedTab == 0 ? LendingType.given : LendingType.taken;
    return controller.lendingsList.where((l) {
      final matchType = l.type == type;
      final matchSearch =
          _searchQuery.isEmpty ||
          l.person.name.toLowerCase().contains(_searchQuery);
      return matchType && matchSearch;
    }).toList();
  }

  double get _totalForTab {
    final type = _selectedTab == 0 ? LendingType.given : LendingType.taken;
    return controller.lendingsList
        .where((l) => l.type == type)
        .fold(0.0, (sum, l) => sum + l.amount);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: const CustomAppBar(title: 'Lend Management'),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.lendingsList.isEmpty) {
            return Column(
              children: [
                _buildHeader(isDark),
                const Expanded(child: LendingShimmerList()),
              ],
            );
          }

          final filtered = _filteredLendings;
          final total = _totalForTab;

          return RefreshIndicator(
            color: AppColors.primaryTeal,
            onRefresh: controller.refreshLendings,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // ── Header (title + tab switcher + search) ──
                SliverToBoxAdapter(child: _buildHeader(isDark)),

                // ── Summary card ──
                SliverToBoxAdapter(child: _buildSummaryCard(isDark, total)),

                // ── Section label ──
                SliverToBoxAdapter(
                  child: _buildSectionHeader(isDark, filtered.length),
                ),

                // ── List ──
                filtered.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(isDark),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index == filtered.length) {
                            return SizedBox(height: 100.h);
                          }
                          return LendingListItem(lending: filtered[index]);
                        }, childCount: filtered.length + 1),
                      ),
              ],
            ),
          );
        }),
      ),

      // ── FAB ──
      floatingActionButton: CustomFAB(
        onPressed: () => context.pushNamed(AppRoutes.addLending),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Header: title row + tab switcher + search bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Given / Taken tab switcher
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                _buildTabPill('Given', 0, isDark),
                _buildTabPill('Taken', 1, isDark),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Search bar
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Manrope',
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () => _searchController.clear(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16.sp,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildTabPill(String label, int index, bool isDark) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 4.r,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Summary card
  // ─────────────────────────────────────────────────────────────
  Widget _buildSummaryCard(bool isDark, double total) {
    final isGiven = _selectedTab == 0;
    final cardBg = isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5);
    final cardBorder = isDark
        ? const Color(0xFF047857)
        : const Color(0xFFA7F3D0);
    final label = isGiven ? 'TOTAL GIVEN' : 'TOTAL TAKEN';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFF6EE7B7)
                          : const Color(0xFF065F46),
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        total.toCurrency(),
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: FaIcon(
                          FontAwesomeIcons.bangladeshiTakaSign,
                          size: 24.sp,
                          color: isDark
                              ? const Color(0xFF6EE7B7)
                              : const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF047857)
                    : const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                isGiven
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: AppColors.primaryTeal,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Section header
  // ─────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(bool isDark, int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ACTIVE RECORDS',
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              letterSpacing: 1.2,
            ),
          ),
          Text(
            '$count record${count == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white30 : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Empty state
  // ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.handshake_outlined,
            size: 64.sp,
            color: isDark ? Colors.white10 : Colors.black12,
          ),
          SizedBox(height: 16.h),
          Text(
            _searchQuery.isEmpty
                ? 'No ${_selectedTab == 0 ? 'Given' : 'Taken'} Records'
                : 'No results for "$_searchQuery"',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white38 : const Color(0xFF64748B),
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              'Tap + to add a lending record',
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Manrope',
                color: isDark ? Colors.white24 : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
