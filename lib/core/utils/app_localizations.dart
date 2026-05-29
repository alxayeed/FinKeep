import 'package:flutter/material.dart';

class AppLocalizations {
  // Supported locales
  static final localeListenable = ValueNotifier<String>('en');

  static String get currentLocale => localeListenable.value;

  static void setLocale(String locale) {
    if (locale == 'en' || locale == 'bn') {
      localeListenable.value = locale;
    }
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'spent_vs_budget': 'Spent vs Budget',
      'remaining': 'Remaining',
      'usage': 'Usage',
      'of': 'of',
      'left': 'left',
      'spending_by_category': 'Spending by Category',
      'spent_budget': 'Spent / Budget',
      'smart_insight': 'Smart Insight',
      'insight_text': "Food spending is 12% lower than last month. You're on track to have \$120 surplus in this category.",
      'summary': 'Summary',
      'details': 'Details',
      'all': 'All',
      'this_week': 'This Week',
      'all_categories': 'All Categories',
      'all_methods': 'All Methods',
      'spent_small': 'Spent',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'home': 'Home',
      'expenses': 'Expenses',
      'lend': 'Lend',
      'invest': 'Invest',
      'settings': 'Settings',
    },
    'bn': {
      'spent_vs_budget': 'ব্যয় বনাম বাজেট',
      'remaining': 'অবশিষ্ট',
      'usage': 'ব্যবহার',
      'of': 'মধ্যে',
      'left': 'বাকি',
      'spending_by_category': 'শ্রেণীভিত্তিক ব্যয়',
      'spent_budget': 'ব্যয় / বাজেট',
      'smart_insight': 'স্মার্ট ইনসাইট',
      'insight_text': "খাবার খরচ গত মাসের চেয়ে ১২% কম। এই শ্রেণীতে আপনার \$১২০ উদ্বৃত্ত থাকার সম্ভাবনা রয়েছে।",
      'summary': 'সারসংক্ষেপ',
      'details': 'বিস্তারিত',
      'all': 'সব',
      'this_week': 'এই সপ্তাহ',
      'all_categories': 'সব ক্যাটাগরি',
      'all_methods': 'সব পদ্ধতি',
      'spent_small': 'ব্যয়িত',
      'today': 'আজ',
      'yesterday': 'গতকাল',
      'home': 'হোম',
      'expenses': 'খরচ',
      'lend': 'ধার',
      'invest': 'বিনিয়োগ',
      'settings': 'সেটিংস',
    }
  };

  static String translate(String key) {
    return _localizedValues[currentLocale]?[key] ?? key;
  }
}
