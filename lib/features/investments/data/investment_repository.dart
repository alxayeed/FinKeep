import '../domain/entities/investment.dart';
import '../domain/entities/return_entry.dart';
import '../domain/enums/investment_status.dart';

class InvestmentRepository {
  final List<Investment> _investments = [];

  InvestmentRepository() {
    _seedDummyData();
  }

  List<Investment> getInvestments() {
    return List.from(_investments);
  }

  void addInvestment(Investment investment) {
    _investments.add(investment);
  }

  void updateInvestment(Investment investment) {
    final index = _investments.indexWhere((i) => i.id == investment.id);
    if (index != -1) {
      _investments[index] = investment;
    }
  }

  void addReturnEntry(String investmentId, ReturnEntry returnEntry) {
    final index = _investments.indexWhere((i) => i.id == investmentId);
    if (index != -1) {
      _investments[index].returns.add(returnEntry);
    }
  }

  // ------------------------------------------------
  // Dummy Data
  // ------------------------------------------------

  void _seedDummyData() {
    if (_investments.isNotEmpty) return;

    _investments.addAll([
      Investment(
        id: 'inv_001',
        title: 'Fixed Deposit – City Bank',
        amountInvested: 100000,
        startDate: DateTime(2024, 1, 10),
        expectedEndDate: DateTime(2025, 1, 10),
        platformName: 'City Bank',
        profitRate: '8.5%',
        // Fixed rate
        expectedROI: 8.5,
        notes: '1 year fixed deposit',
        docLinks:
            'https://drive.google.com/file/d/15mOiSprPqVCF_E0VRm5c4d_F07Vu8FSC/view?usp=sharing',
        transactionId: 'TXN1001',
        transactionMedium: 'Bank Transfer',
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
      ),
      Investment(
        id: 'inv_002',
        title: 'Mutual Fund – ABC Growth',
        amountInvested: 50000,
        startDate: DateTime(2023, 6, 1),
        expectedEndDate: DateTime(2026, 6, 1),
        platformName: 'ABC Asset Management',
        profitRate: '12-15%',
        // Variable rate
        expectedROI: 15,
        notes: 'Long term growth fund',
        docLinks:
            'https://drive.google.com/file/d/15mOiSprPqVCF_E0VRm5c4d_F07Vu8FSC/view?usp=sharing',
        transactionId: 'TXN1002',
        transactionMedium: 'bKash',
        transactionDate: DateTime(2023, 5, 31),
        status: InvestmentStatus.active,
        returns: [],
      ),
      Investment(
        id: 'inv_003',
        title: 'Peer-to-Peer Lending',
        amountInvested: 20000,
        startDate: DateTime(2023, 3, 15),
        expectedEndDate: DateTime(2024, 3, 15),
        platformName: 'LendX',
        profitRate: '18%',
        // Fixed
        expectedROI: 18,
        notes: 'High risk investment',
        docLinks: '',
        transactionId: 'TXN1003',
        transactionMedium: 'MSF',
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
      ),
      Investment(
        id: 'inv_004',
        title: 'Gold Savings Scheme',
        amountInvested: 30000,
        startDate: DateTime(2022, 2, 1),
        expectedEndDate: DateTime(2023, 2, 1),
        platformName: 'GoldMart',
        profitRate: '10-11%',
        // Variable
        expectedROI: 11,
        notes: 'Completed investment',
        docLinks: 'https://github.com/alxayeed',
        transactionId: 'TXN1004',
        transactionMedium: 'Cash',
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
      ),
    ]);
  }
}
