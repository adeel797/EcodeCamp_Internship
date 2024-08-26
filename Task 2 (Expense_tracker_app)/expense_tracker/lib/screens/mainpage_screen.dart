import 'package:flutter/material.dart';
import '../components/info_column.dart';
import '../components/list_structure.dart';
import '../models/transaction_model.dart';

class MainpageScreen extends StatefulWidget {
  final TransactionModel transactionModel;

  MainpageScreen({super.key, required this.transactionModel});

  @override
  State<MainpageScreen> createState() => _MainpageScreenState();
}

class _MainpageScreenState extends State<MainpageScreen> {
  @override
  void initState() {
    super.initState();
    widget.transactionModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: mainPage(context),
    );
  }

  Widget mainPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          dashboardCard(context),
          ListScreen(context),
        ],
      ),
    );
  }

  Widget dashboardCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Infocolumn(
                title: 'Expenses',
                value: widget.transactionModel.totalExpense.toStringAsFixed(0),
              ),
              const SizedBox(width: 20),
              Infocolumn(
                title: 'Income',
                value: widget.transactionModel.totalIncome.toStringAsFixed(0),
              ),
              const SizedBox(width: 20),
              Infocolumn(
                title: 'Balance',
                value: widget.transactionModel.remainingBalance.toStringAsFixed(0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ListScreen(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.transactionModel.transactionData.length,
        itemBuilder: (context, index) {
          return ListStructure(
            taskName: widget.transactionModel.transactionData[index][0],
            description: widget.transactionModel.transactionData[index][1],
            amount: widget.transactionModel.transactionData[index][2].toString(),
            category: widget.transactionModel.transactionData[index][3],
            type: widget.transactionModel.transactionData[index][5],
            date: widget.transactionModel.transactionData[index][4],
            onDelete: () => onDelete(index),
          );
        },
      ),
    );
  }

  void onDelete(int index) {
    setState(() {
      widget.transactionModel.transactionData.removeAt(index);
    });
    widget.transactionModel.updateData();
  }
}
