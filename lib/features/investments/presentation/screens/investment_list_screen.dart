import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/routes/app_router.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../data/investment_repository.dart';
import '../../domain/entities/investment.dart';
import '../widgets/investment_item.dart';
import 'add_investment_screen.dart';

class InvestmentListScreen extends StatefulWidget {
  const InvestmentListScreen({super.key});

  @override
  State<InvestmentListScreen> createState() => _InvestmentListScreenState();
}

class _InvestmentListScreenState extends State<InvestmentListScreen> {
  final InvestmentRepository _repository = InvestmentRepository();
  late List<Investment> _investments;

  @override
  void initState() {
    super.initState();
    _investments = _repository.getInvestments();
  }

  void _addInvestment(Investment investment) {
    setState(() {
      _repository.addInvestment(investment);
      _investments = _repository.getInvestments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Investments'),
      body: _investments.isEmpty
          ? const Center(
              child: Text('No investments yet. Add one!'),
            )
          : ListView.builder(
              itemCount: _investments.length,
              itemBuilder: (context, index) {
                final investment = _investments[index];
                return InvestmentItem(
                  investment: investment,
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.investmentDetails,
                      extra: investment,
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AddInvestmentScreen(onSubmit: _addInvestment),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
