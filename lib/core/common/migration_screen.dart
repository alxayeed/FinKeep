import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';

import '../services/firestore_migration_service.dart';

class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  bool _isMigrating = false;

  Future<void> _startMigration() async {
    setState(() {
      _isMigrating = true;
    });

    try {
      final migrationService = FirestoreMigrationService(
        firestore: FirebaseFirestore.instance,
      );

      final AuthController authController = Get.find();

      await migrationService.migrate(value: authController.user?.email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Migration completed successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Migration failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Migration failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMigrating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final String? migrationValue = authController.user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Migration'),
        backgroundColor: AppColors.primaryTeal,
        centerTitle: true,
      ),
      body: Center(
        child: _isMigrating
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Migration in progress...'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (migrationValue != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Migration will use: $migrationValue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Migration already up to date'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Start Migration',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
