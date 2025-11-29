import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // final authenticator = LocalAuthDeviceAuthenticator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
                image: DecorationImage(
                  opacity: 0.3,
                  image: AssetImage('assets/img/drawer.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            _createDrawerItem(
              icon: Icons.calendar_today_outlined,
              text: 'Expenses',
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.monthlyExpense);
              },
            ),
            _createDrawerItem(
              icon: Icons.monetization_on,
              text: 'Lends',
              onTap: () async {
                Get.back();
                Get.toNamed(AppRoutes.lendingList);

                // final ok = await authenticator.authenticate(
                //   reason: 'Authenticate to access Lends',
                // );
                //
                // if (ok) {
                //   Get.toNamed(AppRoutes.lendingList);
                // } else {
                //   Get.snackbar(
                //     'Authentication failed',
                //     'Unable to unlock Lends section',
                //     snackPosition: SnackPosition.BOTTOM,
                //   );
                // }
              },
            ),
            _createDrawerItem(
              icon: Icons.bar_chart,
              text: 'Reports',
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.expenseReport);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
