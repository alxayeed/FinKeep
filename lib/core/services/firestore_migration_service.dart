import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreMigrationService {
  final FirebaseFirestore firestore;

  FirestoreMigrationService({required this.firestore});

  /// Hardcoded collection and field for migration
  final String collectionName = 'investments_dev';
  final String fieldName = 'userId';

  /// Migrates all documents in the hardcoded collection by setting the hardcoded field to [value].
  /// Prints progress in console.
  Future<void> migrate({required dynamic value, int batchSize = 500}) async {
    final collectionRef = firestore.collection(collectionName);
    final snapshot = await collectionRef.get();

    final docs = snapshot.docs;
    debugPrint('Found ${docs.length} documents in $collectionName');

    if (docs.isEmpty) return;

    int processed = 0;
    WriteBatch batch = firestore.batch();

    for (var doc in docs) {
      batch.update(doc.reference, {fieldName: value});
      processed++;

      // Commit batch if batchSize reached
      if (processed % batchSize == 0) {
        await batch.commit();
        debugPrint(
          'Updated $processed/${docs.length} documents in $collectionName',
        );
        batch = firestore.batch();
      }
    }

    // Commit remaining documents
    if (processed % batchSize != 0) {
      await batch.commit();
      debugPrint(
        'Updated $processed/${docs.length} documents in $collectionName',
      );
    }

    debugPrint('Migration complete for $collectionName');
  }
}
