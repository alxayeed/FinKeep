import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../screens/screens.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      onPressed: () {
        Get.bottomSheet(
          const CreateExpenseScreen(),
          isScrollControlled: true,
        );
      },
      child: const FaIcon(FontAwesomeIcons.plus),
    );
  }
}
