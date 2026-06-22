import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Currency {
  bdt('BDT', '৳', FontAwesomeIcons.bangladeshiTakaSign, 'Bangladeshi Taka'),
  usd('USD', '\$', FontAwesomeIcons.dollarSign, 'US Dollar'),
  eur('EUR', '€', FontAwesomeIcons.euroSign, 'Euro'),
  gbp('GBP', '£', FontAwesomeIcons.sterlingSign, 'British Pound'),
  inr('INR', '₹', FontAwesomeIcons.indianRupeeSign, 'Indian Rupee'),
  // sar('SAR', '﷼', FontAwesomeIcons.moneyBill, 'Saudi Riyal'),
  jpy('JPY', '¥', FontAwesomeIcons.yenSign, 'Japanese Yen');

  final String code;
  final String symbol;
  final FaIconData icon;
  final String name;

  const Currency(this.code, this.symbol, this.icon, this.name);
}
