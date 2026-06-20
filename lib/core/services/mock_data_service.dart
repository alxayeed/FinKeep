import 'package:intl/intl.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/core/enums/expense_category.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/features/expense/data/models/expense_model.dart';
import 'package:finkeep/features/investments/data/models/investment_model.dart';
import 'package:finkeep/features/investments/data/models/return_entry_model.dart';
import 'package:finkeep/features/investments/domain/enums/investment_status.dart';
import 'package:finkeep/features/lendings/data/models/lending/lending_model.dart';
import 'package:finkeep/features/lendings/data/models/lending_person/lending_person_model.dart';
import 'package:finkeep/features/lendings/data/models/repayment/repayment_model.dart';
import 'package:finkeep/features/lendings/domain/entity/lending/lending_entity.dart';

class MockDataService {
  static final LocalDbService _localDb = LocalDbService();

  static Future<void> populateMockData() async {
    // 1. Clear current database
    await _localDb.clearAll();

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    // Helper to get relative dates
    DateTime relativeDate(int dayOffset, {int hour = 12}) {
      final target = now.subtract(Duration(days: dayOffset));
      return DateTime(target.year, target.month, target.day, hour, 0);
    }

    // 2. Populate budgets for multiple months
    final String currentMonthDocId = DateFormat('yyyy-MMMM').format(now);
    final String lastMonthDocId = DateFormat('yyyy-MMMM').format(DateTime(currentYear, currentMonth - 1, 15));
    final String twoMonthsAgoDocId = DateFormat('yyyy-MMMM').format(DateTime(currentYear, currentMonth - 2, 15));
    const String recurringDocId = 'recurring';

    // Current Month Budget (45,000 BDT) - Stays within budget
    final currentBudget = {
      'id': currentMonthDocId,
      'overallBudget': 45000.0,
      'categoryBudgets': {
        ExpenseCategory.food.name: 12000.0,
        ExpenseCategory.transport.name: 6000.0,
        ExpenseCategory.family.name: 15000.0,
        ExpenseCategory.personal.name: 6000.0,
        ExpenseCategory.utilities.name: 4000.0,
        ExpenseCategory.hangout.name: 5000.0,
      },
      'isRecurring': false,
      'month': currentMonthDocId,
      'updatedAt': now.toIso8601String(),
    };

    // Last Month Budget (30,000 BDT) - Will exceed budget
    final lastBudget = {
      'id': lastMonthDocId,
      'overallBudget': 30000.0,
      'categoryBudgets': {
        ExpenseCategory.food.name: 8000.0,
        ExpenseCategory.transport.name: 4000.0,
        ExpenseCategory.family.name: 10000.0,
        ExpenseCategory.personal.name: 3000.0,
        ExpenseCategory.hangout.name: 3000.0,
      },
      'isRecurring': false,
      'month': lastMonthDocId,
      'updatedAt': DateTime(currentYear, currentMonth - 1, 1).toIso8601String(),
    };

    // Two Months Ago Budget (35,000 BDT) - Stays within budget
    final twoMonthsAgoBudget = {
      'id': twoMonthsAgoDocId,
      'overallBudget': 35000.0,
      'categoryBudgets': {
        ExpenseCategory.food.name: 10000.0,
        ExpenseCategory.transport.name: 5000.0,
        ExpenseCategory.family.name: 12000.0,
        ExpenseCategory.utilities.name: 4000.0,
      },
      'isRecurring': false,
      'month': twoMonthsAgoDocId,
      'updatedAt': DateTime(currentYear, currentMonth - 2, 1).toIso8601String(),
    };

    // Recurring fallback
    final recurringBudget = Map<String, dynamic>.from(currentBudget)
      ..['id'] = recurringDocId
      ..['isRecurring'] = true;

    await _localDb.budgetsBox.put(recurringDocId, recurringBudget);
    await _localDb.budgetsBox.put(currentMonthDocId, currentBudget);
    await _localDb.budgetsBox.put(lastMonthDocId, lastBudget);
    await _localDb.budgetsBox.put(twoMonthsAgoDocId, twoMonthsAgoBudget);

    // 3. Populate Persons
    final persons = [
      const LendingPersonModel(
        id: 'p_1',
        name: 'Tasnim Ahmed',
        contactNumber: '+8801712345678',
        email: 'tasnim@example.com',
        notes: 'University Friend',
      ),
      const LendingPersonModel(
        id: 'p_2',
        name: 'Rashedul Karim',
        contactNumber: '+8801812345679',
        email: 'rashed@example.com',
        notes: 'Office Colleague',
      ),
      const LendingPersonModel(
        id: 'p_3',
        name: 'Sarah Islam',
        contactNumber: '+8801912345680',
        email: 'sarah@example.com',
        notes: 'Cousin',
      ),
      const LendingPersonModel(
        id: 'p_4',
        name: 'Anisur Rahman',
        contactNumber: '+8801512345681',
        email: 'anis@example.com',
        notes: 'Landlord',
      ),
    ];

    for (var p in persons) {
      await _localDb.personsBox.put(p.id, p.toJson());
    }

    // 4. Populate Expenses (Screenful, distributed across 3 months, covering ALL categories & payment methods)
    final expenses = [
      // ==========================================
      // MONTH 1: CURRENT MONTH (Stays within Budget - Total: ~31,650 BDT)
      // ==========================================
      ExpenseModel(
        id: 'c_exp_1',
        amount: 1250.0,
        category: ExpenseCategory.food.name,
        date: relativeDate(1, hour: 13),
        description: 'Family Dinner at Pizza Hut',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(1, hour: 13),
      ),
      ExpenseModel(
        id: 'c_exp_2',
        amount: 3200.0,
        category: ExpenseCategory.food.name,
        date: relativeDate(2, hour: 18),
        description: 'Monthly Grocery at Chaldal',
        paymentMethod: PaymentType.mfs,
        createdAt: relativeDate(2, hour: 18),
      ),
      ExpenseModel(
        id: 'c_exp_3',
        amount: 850.0,
        category: ExpenseCategory.transport.name,
        date: relativeDate(3, hour: 9),
        description: 'Uber Premium Ride to Client Office',
        paymentMethod: PaymentType.mfs,
        createdAt: relativeDate(3, hour: 9),
      ),
      ExpenseModel(
        id: 'c_exp_4',
        amount: 4200.0,
        category: ExpenseCategory.utilities.name,
        date: relativeDate(5, hour: 11),
        description: 'DESCO Electricity Bill',
        paymentMethod: PaymentType.transfer,
        createdAt: relativeDate(5, hour: 11),
      ),
      ExpenseModel(
        id: 'c_exp_5',
        amount: 2200.0,
        category: ExpenseCategory.hangout.name,
        date: relativeDate(4, hour: 20),
        description: 'Buffet Dinner with Colleagues',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(4, hour: 20),
      ),
      ExpenseModel(
        id: 'c_exp_6',
        amount: 1500.0,
        category: ExpenseCategory.personal.name,
        date: relativeDate(7, hour: 10),
        description: 'Premium Gym Monthly Fees',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(7, hour: 10),
      ),
      ExpenseModel(
        id: 'c_exp_7',
        amount: 4500.0,
        category: ExpenseCategory.clothing.name,
        date: relativeDate(8, hour: 16),
        description: 'Eid Shopping - Panjabi & Shoes',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(8, hour: 16),
      ),
      ExpenseModel(
        id: 'c_exp_8',
        amount: 600.0,
        category: ExpenseCategory.food.name,
        date: relativeDate(10, hour: 17),
        description: 'Starbucks Coffee & Dessert',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(10, hour: 17),
      ),
      ExpenseModel(
        id: 'c_exp_9',
        amount: 2800.0,
        category: ExpenseCategory.family.name,
        date: relativeDate(6, hour: 12),
        description: 'Monthly Medicine for Parents',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(6, hour: 12),
      ),
      ExpenseModel(
        id: 'c_exp_10',
        amount: 1000.0,
        category: ExpenseCategory.utilities.name,
        date: relativeDate(9, hour: 15),
        description: 'Link3 Internet Broadband Bill',
        paymentMethod: PaymentType.mfs,
        createdAt: relativeDate(9, hour: 15),
      ),
      ExpenseModel(
        id: 'c_exp_11',
        amount: 3000.0,
        category: ExpenseCategory.transport.name,
        date: relativeDate(11, hour: 8),
        description: 'Octane Fuel Refill for Car',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(11, hour: 8),
      ),
      ExpenseModel(
        id: 'c_exp_12',
        amount: 1500.0,
        category: ExpenseCategory.lend.name,
        date: relativeDate(12, hour: 14),
        description: 'Small loan to helper staff',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(12, hour: 14),
      ),
      ExpenseModel(
        id: 'c_exp_13',
        amount: 350.0,
        category: ExpenseCategory.other.name,
        date: relativeDate(13, hour: 11),
        description: 'Mobile Recharge (Grameenphone)',
        paymentMethod: PaymentType.mfs,
        createdAt: relativeDate(13, hour: 11),
      ),
      ExpenseModel(
        id: 'c_exp_14',
        amount: 4700.0,
        category: ExpenseCategory.family.name,
        date: relativeDate(14, hour: 10),
        description: 'Dry Bazaar and Kitchen stock',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(14, hour: 10),
      ),

      // ==========================================
      // MONTH 2: LAST MONTH (Exceeds Budget 30,000 BDT - Total: ~43,800 BDT)
      // ==========================================
      ExpenseModel(
        id: 'l_exp_1',
        amount: 12000.0,
        category: ExpenseCategory.family.name,
        date: relativeDate(25, hour: 12),
        description: 'Home Rent Contribution',
        paymentMethod: PaymentType.transfer,
        createdAt: relativeDate(25, hour: 12),
      ),
      ExpenseModel(
        id: 'l_exp_2',
        amount: 5200.0,
        category: ExpenseCategory.clothing.name,
        date: relativeDate(22, hour: 15),
        description: 'Formal Suite and Leather Shoes',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(22, hour: 15),
      ),
      ExpenseModel(
        id: 'l_exp_3',
        amount: 8600.0,
        category: ExpenseCategory.utilities.name,
        date: relativeDate(24, hour: 11),
        description: 'WASA & Titas Gas Bill & Service Charge',
        paymentMethod: PaymentType.mfs,
        createdAt: relativeDate(24, hour: 11),
      ),
      ExpenseModel(
        id: 'l_exp_4',
        amount: 4300.0,
        category: ExpenseCategory.food.name,
        date: relativeDate(26, hour: 20),
        description: 'Weekly grocery at Shwapno supermarket',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(26, hour: 20),
      ),
      ExpenseModel(
        id: 'l_exp_5',
        amount: 3500.0,
        category: ExpenseCategory.transport.name,
        date: relativeDate(27, hour: 8),
        description: 'CNG Fare Monthly Package / Passes',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(27, hour: 8),
      ),
      ExpenseModel(
        id: 'l_exp_6',
        amount: 6000.0,
        category: ExpenseCategory.hangout.name,
        date: relativeDate(29, hour: 21),
        description: 'Resort booking for weekend gateway',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(29, hour: 21),
      ),
      ExpenseModel(
        id: 'l_exp_7',
        amount: 2200.0,
        category: ExpenseCategory.other.name,
        date: relativeDate(32, hour: 16),
        description: 'Car denting paint workshop',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(32, hour: 16),
      ),
      ExpenseModel(
        id: 'l_exp_8',
        amount: 2000.0,
        category: ExpenseCategory.personal.name,
        date: relativeDate(35, hour: 14),
        description: 'Skin care products and trimmer',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(35, hour: 14),
      ),

      // ==========================================
      // MONTH 3: TWO MONTHS AGO (Within Budget 35,000 BDT - Total: ~16,400 BDT)
      // ==========================================
      ExpenseModel(
        id: '2l_exp_1',
        amount: 5000.0,
        category: ExpenseCategory.family.name,
        date: relativeDate(58, hour: 11),
        description: 'Family gifts',
        paymentMethod: PaymentType.mfs,
        createdAt: relativeDate(58, hour: 11),
      ),
      ExpenseModel(
        id: '2l_exp_2',
        amount: 3200.0,
        category: ExpenseCategory.food.name,
        date: relativeDate(62, hour: 14),
        description: 'Office catering & lunches',
        paymentMethod: PaymentType.cash,
        createdAt: relativeDate(62, hour: 14),
      ),
      ExpenseModel(
        id: '2l_exp_3',
        amount: 1800.0,
        category: ExpenseCategory.transport.name,
        date: relativeDate(65, hour: 19),
        description: 'Pathao/Uber Bike rides',
        paymentMethod: PaymentType.mfs,
        createdAt: relativeDate(65, hour: 19),
      ),
      ExpenseModel(
        id: '2l_exp_4',
        amount: 4000.0,
        category: ExpenseCategory.utilities.name,
        date: relativeDate(68, hour: 12),
        description: 'Quarterly Water supply bills',
        paymentMethod: PaymentType.transfer,
        createdAt: relativeDate(68, hour: 12),
      ),
      ExpenseModel(
        id: '2l_exp_5',
        amount: 2400.0,
        category: ExpenseCategory.hangout.name,
        date: relativeDate(70, hour: 20),
        description: 'Aarong shopping & cafe',
        paymentMethod: PaymentType.card,
        createdAt: relativeDate(70, hour: 20),
      ),
    ];

    for (var exp in expenses) {
      await _localDb.expensesBox.put(exp.id, exp.toJson());
    }

    // 5. Populate Repayments
    final repayments = [
      RepaymentModel(
        id: 'rep_1',
        lendingId: 'lend_1',
        amount: 10000.0,
        paidDate: relativeDate(12, hour: 10),
        notes: 'Paid via bKash Transfer',
      ),
      RepaymentModel(
        id: 'rep_2',
        lendingId: 'lend_2',
        amount: 8000.0,
        paidDate: relativeDate(15, hour: 11),
        notes: 'First installment repaid',
      ),
      RepaymentModel(
        id: 'rep_3',
        lendingId: 'lend_2',
        amount: 4000.0,
        paidDate: relativeDate(5, hour: 14),
        notes: 'Second installment repaid',
      ),
      RepaymentModel(
        id: 'rep_4',
        lendingId: 'lend_3',
        amount: 3000.0,
        paidDate: relativeDate(3, hour: 16),
        notes: 'Partial repayment returned back',
      ),
    ];

    for (var rep in repayments) {
      await _localDb.repaymentsBox.put(rep.id, rep.toJson());
    }

    // 6. Populate Lendings (Given & Taken, Paid & Overdue & Partial statuses)
    final lendings = [
      // Lending 1: Given, Paid
      LendingModel(
        id: 'lend_1',
        type: LendingType.given,
        personId: 'p_1',
        person: persons[0],
        amount: 10000.0,
        repaidAmount: 10000.0,
        description: 'Urgent medical loan to Tasnim',
        createdDate: relativeDate(25, hour: 10),
        dueDate: relativeDate(12, hour: 18),
        status: LendingStatus.paid,
        paymentMethod: PaymentType.mfs,
        repayments: [repayments[0]],
      ),
      // Lending 2: Given, Partial
      LendingModel(
        id: 'lend_2',
        type: LendingType.given,
        personId: 'p_2',
        person: persons[1],
        amount: 20000.0,
        repaidAmount: 12000.0,
        description: 'Laptop purchase support',
        createdDate: relativeDate(30, hour: 9),
        dueDate: relativeDate(-15, hour: 18), // Future date
        status: LendingStatus.partial,
        paymentMethod: PaymentType.transfer,
        repayments: [repayments[1], repayments[2]],
      ),
      // Lending 3: Taken, Partial
      LendingModel(
        id: 'lend_3',
        type: LendingType.taken,
        personId: 'p_3',
        person: persons[2],
        amount: 8000.0,
        repaidAmount: 3000.0,
        description: 'Borrowed for event expense from Sarah',
        createdDate: relativeDate(8, hour: 12),
        dueDate: relativeDate(-10, hour: 18), // Future date
        status: LendingStatus.partial,
        paymentMethod: PaymentType.cash,
        repayments: [repayments[3]],
      ),
      // Lending 4: Given, Overdue
      LendingModel(
        id: 'lend_4',
        type: LendingType.given,
        personId: 'p_1',
        person: persons[0],
        amount: 5000.0,
        repaidAmount: 0.0,
        description: 'Semester fees loan',
        createdDate: relativeDate(45, hour: 11),
        dueDate: relativeDate(15, hour: 18), // Overdue by 15 days
        status: LendingStatus.overdue,
        paymentMethod: PaymentType.mfs,
        repayments: [],
      ),
      // Lending 5: Taken, Due
      LendingModel(
        id: 'lend_5',
        type: LendingType.taken,
        personId: 'p_4',
        person: persons[3],
        amount: 15000.0,
        repaidAmount: 0.0,
        description: 'Borrowed for Home repair materials',
        createdDate: relativeDate(4, hour: 10),
        dueDate: relativeDate(-25, hour: 18), // Future date
        status: LendingStatus.due,
        paymentMethod: PaymentType.transfer,
        repayments: [],
      ),
    ];

    for (var lend in lendings) {
      final json = lend.toJson();
      if (lend.repayments != null) {
        json['repayments'] = lend.repayments!.map((r) => r.toJson()).toList();
      }
      json['person'] = lend.person.toJson();
      await _localDb.lendingsBox.put(lend.id, json);
    }

    // 7. Populate Investments (with dividend returns)
    final investments = [
      InvestmentModel(
        id: 'inv_1',
        title: 'IDLC SIP Mutual Fund',
        amountInvested: 30000.0,
        startDate: relativeDate(120),
        expectedEndDate: relativeDate(-270), // Future date
        platformName: 'IDLC Asset Management',
        profitRate: '8.75%',
        expectedROI: 2625.0,
        notes: 'Monthly SIP installment of 5,000 BDT.',
        docLinks: 'https://idlc.com/mutual-fund-portal',
        transactionId: 'TXN-SIP-8980',
        transactionMedium: PaymentType.transfer,
        transactionDate: relativeDate(120),
        status: InvestmentStatus.returnsStarted,
        returns: [
          ReturnEntryModel(
            id: 'ret_1',
            amountReceived: 800.0,
            date: relativeDate(90),
            transactionId: 'TXN-SIP-RET01',
            medium: 'Bank Transfer',
            notes: 'Q1 Dividend dividend payout',
          ),
          ReturnEntryModel(
            id: 'ret_2',
            amountReceived: 800.0,
            date: relativeDate(30),
            transactionId: 'TXN-SIP-RET02',
            medium: 'Bank Transfer',
            notes: 'Q2 Dividend dividend payout',
          ),
        ],
      ),
      InvestmentModel(
        id: 'inv_2',
        title: 'Govt 3-Year Sanchayapatra',
        amountInvested: 150000.0,
        startDate: relativeDate(45),
        expectedEndDate: relativeDate(-1000), // Future date
        platformName: 'Bangladesh Bank',
        profitRate: '11.04%',
        expectedROI: 49680.0,
        notes: 'Purchased national savings certificate at central bank branch.',
        docLinks: 'https://bangladeshbank.org.bd',
        transactionId: 'TXN-SP-44221',
        transactionMedium: PaymentType.cash,
        transactionDate: relativeDate(45),
        status: InvestmentStatus.active,
        returns: [],
      ),
      InvestmentModel(
        id: 'inv_3',
        title: 'BEXIMCO Stocks',
        amountInvested: 25000.0,
        startDate: relativeDate(150),
        expectedEndDate: relativeDate(10), // Sold 10 days ago
        platformName: 'LankaBangla Securities',
        profitRate: '12%',
        expectedROI: 3000.0,
        notes: 'Bought low, exited on target.',
        docLinks: '',
        transactionId: 'TXN-LB-38101',
        transactionMedium: PaymentType.card,
        transactionDate: relativeDate(150),
        status: InvestmentStatus.completed,
        returns: [
          ReturnEntryModel(
            id: 'ret_3',
            amountReceived: 29500.0,
            date: relativeDate(10),
            transactionId: 'TXN-LB-SELL-01',
            medium: 'BO Account Transfer',
            notes: 'Exited stocks at profit margin',
          ),
        ],
      ),
    ];

    for (var inv in investments) {
      await _localDb.investmentsBox.put(inv.id, inv.toJson());
    }
  }
}
