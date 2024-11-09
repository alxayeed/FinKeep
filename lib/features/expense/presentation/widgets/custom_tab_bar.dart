import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomTabBar({super.key});


  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.white,
      tabs: const [
        Tab(text: 'Overview'),
        Tab(text: 'Expenses'),
      ],
    );
  }


}
