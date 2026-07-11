import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Performance & Memory Benchmark Tests', () {
    test('Benchmark: BackupService N x M Query Traversal', () {
      const int N = 100; // 100 lendings
      const int M = 500; // 500 repayments
      
      final repayments = List.generate(M, (i) => {
        'id': 'rep_$i',
        'lendingId': 'lend_${i % N}',
        'amount': 100.0,
      });

      // 1. Current nesting lookup algorithm
      final stopwatchCurrent = Stopwatch()..start();
      int currentMatchCount = 0;
      for (int i = 0; i < N; i++) {
        final docId = 'lend_$i';
        final matching = repayments.where((r) => r['lendingId'] == docId).toList();
        currentMatchCount += matching.length;
      }
      stopwatchCurrent.stop();
      
      // 2. Proposed pre-grouped mapping algorithm
      final stopwatchProposed = Stopwatch()..start();
      int proposedMatchCount = 0;
      final Map<String, List<Map<String, dynamic>>> repaymentsByLendingId = {};
      for (final r in repayments) {
        final lendingId = r['lendingId'] as String?;
        if (lendingId != null) {
          repaymentsByLendingId.putIfAbsent(lendingId, () => []).add(r);
        }
      }
      for (int i = 0; i < N; i++) {
        final docId = 'lend_$i';
        final matching = repaymentsByLendingId[docId] ?? [];
        proposedMatchCount += matching.length;
      }
      stopwatchProposed.stop();

      print('=== Performance Benchmark Results ===');
      print('Current algorithm (N x M scan) time: ${stopwatchCurrent.elapsedMicroseconds} microseconds');
      print('Proposed algorithm (O(N+M) map lookup) time: ${stopwatchProposed.elapsedMicroseconds} microseconds');
      print('Traversals match: ${currentMatchCount == proposedMatchCount} ($currentMatchCount records)');
      
      expect(currentMatchCount, M);
      expect(proposedMatchCount, M);
    });
  });
}
