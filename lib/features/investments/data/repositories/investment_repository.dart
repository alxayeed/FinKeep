import 'package:flutter/foundation.dart';
import 'package:finkeep/core/config/app_config.dart';

import '../../domain/entities/investment.dart';
import '../../domain/entities/return_entry.dart';
import '../../domain/repositories/investment_repository.dart';
import '../datasources/investment_data_source.dart';
import '../datasources/investment_local_datasource.dart';
import '../models/investment_model.dart';
import '../models/return_entry_model.dart';

class InvestmentRepositoryImpl implements InvestmentRepository {
  final InvestmentLocalDataSource _localDataSource;
  final InvestmentDataSource _remoteDataSource;

  InvestmentRepositoryImpl({
    required InvestmentLocalDataSource localDataSource,
    required InvestmentDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<List<Investment>> getInvestments() async {
    try {
      if (AppConfig.isPersonal) {
        final models = await _remoteDataSource.getInvestments();
        return models.map((m) => m).toList();
      } else {
        final models = await _localDataSource.getInvestments();
        return models.map((m) => m).toList();
      }
    } catch (e, s) {
      debugPrint('InvestmentRepositoryImpl.getInvestments error: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<void> addInvestment(Investment investment) async {
    final model = InvestmentModel.fromEntity(investment);
    try {
      if (AppConfig.isPersonal) {
        try {
          await _remoteDataSource.addInvestment(model);
        } catch (e) {
          // Will be handled by background sync
        }
      } else {
        await _localDataSource.addInvestment(model);
      }
    } catch (e, s) {
      debugPrint('InvestmentRepositoryImpl.addInvestment error: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<void> updateInvestment(Investment investment) async {
    final model = InvestmentModel.fromEntity(investment);
    try {
      if (AppConfig.isPersonal) {
        try {
          await _remoteDataSource.updateInvestment(model);
        } catch (e) {
          // Will be handled by background sync
        }
      } else {
        await _localDataSource.updateInvestment(model);
      }
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
      if (AppConfig.isPersonal) {
        try {
          await _remoteDataSource.addReturnEntry(investmentId, model);
        } catch (e) {
          // Will be handled by background sync
        }
      } else {
        await _localDataSource.addReturnEntry(investmentId, model);
      }
    } catch (e, s) {
      debugPrint('InvestmentRepositoryImpl.addReturnEntry error: $e\n$s');
      rethrow;
    }
  }
}
