import 'package:flutter/foundation.dart';
import 'package:spendly/core/enums/payment_type.dart';
import '../../domain/entities/investment.dart';
import '../../domain/entities/return_entry.dart';
import '../../domain/enums/investment_status.dart';
import '../../domain/repositories/investment_repository.dart';
import '../datasources/investment_data_source.dart';
import '../models/investment_model.dart';
import '../models/return_entry_model.dart';

/// Repository Implementation connecting domain with data source.
/// Currently uses dummy data, but methods are ready to interact with real data source.
class InvestmentRepositoryImpl implements InvestmentRepository {
  final InvestmentDataSource _dataSource;
  final List<Investment> _dummyInvestments = [];

  InvestmentRepositoryImpl({required InvestmentDataSource dataSource})
    : _dataSource = dataSource {
    _seedDummyData();
  }

  @override
  Future<List<Investment>> getInvestments(String userId) async {
    try {
      final models = await _dataSource.getInvestments(userId);
      return models.map((m) => m).toList();
    } catch (e, s) {
      debugPrint('InvestmentRepositoryImpl.getInvestments error: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<void> addInvestment(Investment investment) async {
    final model = InvestmentModel.fromEntity(investment);
    try {
      await _dataSource.addInvestment(model);
    } catch (e, s) {
      debugPrint('InvestmentRepositoryImpl.addInvestment error: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<void> updateInvestment(Investment investment) async {
    final model = InvestmentModel.fromEntity(investment);
    try {
      await _dataSource.updateInvestment(model);
    } catch (e, s) {
      debugPrint('InvestmentRepositoryImpl.updateInvestment error: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<void> addReturnEntry(
    String investmentId,
    ReturnEntry returnEntry,
  ) async {
    final model = ReturnEntryModel.fromEntity(returnEntry);
    try {
      await _dataSource.addReturnEntry(investmentId, model);
    } catch (e, s) {
      debugPrint('InvestmentRepositoryImpl.addReturnEntry error: $e\n$s');
      rethrow;
    }
  }

  // ------------------------------------------------
  // Dummy Data (for offline/dev/testing)
  // ------------------------------------------------
  void _seedDummyData() {
    if (_dummyInvestments.isNotEmpty) return;

    _dummyInvestments.addAll([
      Investment(
        id: 'inv_001',
        title: 'Fixed Deposit – City Bank',
        amountInvested: 100000,
        startDate: DateTime(2024, 1, 10),
        expectedEndDate: DateTime(2025, 1, 10),
        platformName: 'City Bank',
        profitRate: '8.5%',
        expectedROI: 8.5,
        notes: '1 year fixed deposit',
        docLinks:
            'https://drive.google.com/file/d/15mOiSprPqVCF_E0VRm5c4d_F07Vu8FSC/view?usp=sharing',
        transactionId: 'TXN1001',
        transactionMedium: PaymentType.transfer,
        transactionDate: DateTime(2024, 1, 9),
        status: InvestmentStatus.returnsStarted,
        returns: [
          ReturnEntry(
            id: 'ret_001',
            amountReceived: 3500,
            date: DateTime(2024, 4, 10),
            transactionId: 'RTXN2001',
            medium: 'Bank Transfer',
            notes: 'Quarterly profit',
          ),
          ReturnEntry(
            id: 'ret_002',
            amountReceived: 3500,
            date: DateTime(2024, 7, 10),
            transactionId: 'RTXN2002',
            medium: 'Bank Transfer',
            notes: 'Quarterly profit',
          ),
        ],
        userId: 'unknown_user',
      ),
      Investment(
        id: 'inv_002',
        title: 'Mutual Fund – ABC Growth',
        amountInvested: 50000,
        startDate: DateTime(2023, 6, 1),
        expectedEndDate: DateTime(2026, 6, 1),
        platformName: 'ABC Asset Management',
        profitRate: '12-15%',
        expectedROI: 15,
        notes: 'Long term growth fund',
        docLinks:
            'https://drive.google.com/drive/folders/1-dK75DbFK2rzBCekDjk2uICqzJHyaqzQ?usp=sharing',
        transactionId: 'TXN1002',
        transactionMedium: PaymentType.mfs,
        transactionDate: DateTime(2023, 5, 31),
        status: InvestmentStatus.active,
        returns: [],
        userId: 'unknown_user',
      ),
      Investment(
        id: 'inv_003',
        title: 'Peer-to-Peer Lending',
        amountInvested: 20000,
        startDate: DateTime(2023, 3, 15),
        expectedEndDate: DateTime(2024, 3, 15),
        platformName: 'LendX',
        profitRate: '18%',
        expectedROI: 18,
        notes: 'High risk investment',
        docLinks: '',
        transactionId: 'TXN1003',
        transactionMedium: PaymentType.mfs,
        transactionDate: DateTime(2023, 3, 14),
        status: InvestmentStatus.loss,
        returns: [
          ReturnEntry(
            id: 'ret_003',
            amountReceived: 5000,
            date: DateTime(2023, 8, 15),
            transactionId: 'RTXN3001',
            medium: 'MSF',
            notes: 'Partial recovery',
          ),
        ],
        userId: '',
      ),
      Investment(
        id: 'inv_004',
        title: 'Gold Savings Scheme',
        amountInvested: 30000,
        startDate: DateTime(2022, 2, 1),
        expectedEndDate: DateTime(2023, 2, 1),
        platformName: 'GoldMart',
        profitRate: '10-11%',
        expectedROI: 11,
        notes: 'Completed investment',
        docLinks: 'https://github.com/alxayeed',
        transactionId: 'TXN1004',
        transactionMedium: PaymentType.cash,
        transactionDate: DateTime(2022, 1, 31),
        status: InvestmentStatus.completed,
        returns: [
          ReturnEntry(
            id: 'ret_004',
            amountReceived: 33000,
            date: DateTime(2023, 2, 1),
            transactionId: 'RTXN4001',
            medium: 'Cash',
            notes: 'Final settlement',
          ),
        ],
        userId: 'unknown_user',
      ),
    ]);
  }
}
