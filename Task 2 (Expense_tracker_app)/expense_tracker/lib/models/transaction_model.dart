import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class TransactionModel {
  List transactionData = [];
  double remainingBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double budget = 0.0;
  double remainingBudget = 0.0;
  double currentMonthExpense = 0.0;
  final box = Hive.box("transactionData");

  TransactionModel() {
    loadData();
  }

  void updateData() {
    box.put("transaction_data", transactionData);
    calculateRemainingBalance();
  }

  void loadData() {
    var storedData = box.get("transaction_data");
    var storedBudget = box.get("budget");

    if (storedData != null) {
      transactionData = List.from(storedData);
    }
    if (storedBudget != null) {
      budget = storedBudget;
    }

    calculateRemainingBalance();
  }

  void calculateRemainingBalance() {
    totalIncome = 0.0;
    totalExpense = 0.0;

    for (var transaction in transactionData) {
      double amount = transaction[2];
      if (transaction[5] == 'income') {
        totalIncome += amount;
      } else if (transaction[5] == 'expense') {
        totalExpense += amount;
      }
    }

    // Calculate the total expense for the current month
    currentMonthExpense = _getCurrentMonthExpense();

    // Calculate remaining budget by deducting current month's expense from the total budget
    remainingBudget = budget - currentMonthExpense;

    // Calculate remaining balance
    remainingBalance = totalIncome - totalExpense;

    // Debugging information
    print('Total Income: $totalIncome');
    print('Total Expense: $totalExpense');
    print('Current Month Expense: $currentMonthExpense');
    print('Remaining Budget: $remainingBudget');
  }

  double _getCurrentMonthExpense() {
    double currentMonthExpense = 0.0;
    String currentMonth = DateFormat('MM-yyyy').format(DateTime.now());

    for (var transaction in transactionData) {
      if (transaction[5] == 'expense' && _getFormattedDate(transaction[4]) == currentMonth) {
        currentMonthExpense += transaction[2];
      }
    }

    return currentMonthExpense;
  }

  String _getFormattedDate(String date) {
    try {
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      return DateFormat('MM-yyyy').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return "";
    }
  }

  void setBudget(double budgetAmount) {
    budget = budgetAmount;
    box.put("budget", budgetAmount);
    calculateRemainingBalance();
  }

  void addIncome(String name, String description, double amount, String category, String date) {
    transactionData.insert(0, [name, description.isEmpty ? "NULL" : description, amount, category, date, 'income']);
    updateData();
  }

  void addExpense(String name, String description, double amount, String category, String date) {
    transactionData.insert(0, [name, description.isEmpty ? "NULL" : description, amount, category, date, 'expense']);
    updateData();
  }
}
