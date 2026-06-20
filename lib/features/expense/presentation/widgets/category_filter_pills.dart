import 'package:flutter/material.dart';
import '../../../../core/enums/expense_category.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_localizations.dart';

class CategoryFilterPills extends StatefulWidget {
  final ExpenseCategory? selectedCategory;
  final ValueChanged<ExpenseCategory?> onCategorySelected;
  final String searchQuery;
  final ValueChanged<String> onSearchQueryChanged;

  const CategoryFilterPills({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.searchQuery,
    required this.onSearchQueryChanged,
  });

  @override
  State<CategoryFilterPills> createState() => _CategoryFilterPillsState();
}

class _CategoryFilterPillsState extends State<CategoryFilterPills> {
  bool _isSearching = false;
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.searchQuery);
    if (widget.searchQuery.isNotEmpty) {
      _isSearching = true;
    }
  }

  @override
  void didUpdateWidget(CategoryFilterPills oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != _textController.text) {
      _textController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Add "All" to the list of choices
    final List<ExpenseCategory?> categories = [null, ...ExpenseCategory.values];

    return SizedBox(
      height: 38.h,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isSearching
            ? _buildSearchBar(isDark)
            : _buildCategoryListWithSearchButton(context, categories, isDark),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      key: const ValueKey('search_bar'),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(9999.r),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            Icon(
              Icons.search_rounded,
              size: 16.sp,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                onChanged: widget.onSearchQueryChanged,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Manrope',
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'Search description or amount...',
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Manrope',
                    color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSearching = false;
                  _textController.clear();
                });
                widget.onSearchQueryChanged('');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.sp,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListWithSearchButton(
    BuildContext context,
    List<ExpenseCategory?> categories,
    bool isDark,
  ) {
    return Padding(
      key: const ValueKey('category_list'),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Category List with Fade
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.85, 0.97, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 20.w), // spacing for fade
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = widget.selectedCategory == cat;
                  final String displayName = cat == null 
                      ? AppLocalizations.translate('all') 
                      : cat.displayName;

                  return GestureDetector(
                    onTap: () => widget.onCategorySelected(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.primaryTeal : const Color(0xFF0F172A))
                            : (isDark ? const Color(0xFF1E293B) : Colors.white),
                        borderRadius: BorderRadius.circular(9999.r),
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? AppColors.primaryTeal : const Color(0xFF0F172A))
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: isDark 
                                      ? AppColors.primaryTeal.withValues(alpha: 0.3) 
                                      : Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4.r,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : const Color(0xFF475569)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Fixed Search Button
          GestureDetector(
            onTap: () {
              setState(() {
                _isSearching = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _focusNode.requestFocus();
              });
            },
            child: Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(9999.r),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
