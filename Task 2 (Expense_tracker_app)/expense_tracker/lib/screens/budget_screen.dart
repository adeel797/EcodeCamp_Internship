import 'package:flutter/material.dart';

import '../components/info_column.dart';
import '../components/list_structure.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

class BudgetScreen extends StatefulWidget {
  BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController budgetController = TextEditingController();
  late String currentMonth;
  DateTime date = DateTime.now();
  TransactionModel transactionModel = TransactionModel();
  List<Map<String, dynamic>> currentMonthExpenses = [];

  @override
  void initState() {
    super.initState();
    currentMonth = "${date.month}-${date.year}";
    _loadCurrentMonthExpenses();
  }

  void _loadCurrentMonthExpenses() {
    currentMonthExpenses = transactionModel.transactionData
        .where((transaction) =>
    _getFormattedDate(transaction[4]) == currentMonth &&
        transaction[5] == 'expense')
        .map((transaction) => {
      'name': transaction[0],
      'description': transaction[1],
      'amount': transaction[2],
      'category': transaction[3],
      'date': transaction[4],
    })
        .toList();
    setState(() {});
  }

  String _getFormattedDate(String date) {
    // Assuming the date is stored as a string in a consistent format
    try {
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      return "${parsedDate.month}-${parsedDate.year}";
    } catch (e) {
      print("Error parsing date: $e");
      return "";
    }
  }

  void _showSetBudgetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Budget for $currentMonth'),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter budget amount',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? budgetAmount = double.tryParse(budgetController.text);
                if (budgetAmount != null) {
                  setState(() {
                    transactionModel.setBudget(budgetAmount);
                    _loadCurrentMonthExpenses();
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: budgetpage(),
    );
  }

  Widget budgetpage(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget for $currentMonth',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showSetBudgetDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          dashboardCard(context),
          const SizedBox(height: 10,),
          Text(
            'Expenses this month',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10,),
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
                title: 'Budget',
                value: transactionModel.budget.toStringAsFixed(0),
              ),
              const SizedBox(width: 20),
              Infocolumn(
                title: 'Expense',
                value: transactionModel.currentMonthExpense.toStringAsFixed(0),
              ),
              const SizedBox(width: 20),
              Infocolumn(
                title: 'Remaining',
                value: transactionModel.remainingBudget.toStringAsFixed(0),
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
        itemCount: currentMonthExpenses.length,
        itemBuilder: (context, index) {
          var expense = currentMonthExpenses[index];
          return ListStructure(
            taskName: expense['name'],
            amount: expense['amount'].toStringAsFixed(2),
            type: 'expense',
            description: expense['description'],
            category: expense['category'],
            date: expense['date'],
            onDelete: () {
              setState(() {
                transactionModel.transactionData.removeAt(index);
                transactionModel.updateData();
                _loadCurrentMonthExpenses();
              });
            },
          );
        },
      ),
    );
  }
}
