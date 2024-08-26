import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/screens/add_new_screen.dart';
import 'package:expense_tracker/screens/add_transaction_screen.dart';
import 'package:expense_tracker/screens/budget_screen.dart';
import 'package:expense_tracker/screens/mainpage_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
class DashboardScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  bool isDarkMode;
  DashboardScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  DateTime now = DateTime.now();
  int selectedTab = 0;
  final ValueNotifier<TransactionModel> transactionModelNotifier = ValueNotifier(TransactionModel());

  @override
  void initState() {
    super.initState();
    loadTransactionData();
  }

  void loadTransactionData() {
    var box = Hive.box("transactionData");

    if (box.get("transaction_data") == null) {
      transactionModelNotifier.value.loadData();
    } else {
      setState(() {
        transactionModelNotifier.value.transactionData = List.from(box.get("transaction_data"));
        transactionModelNotifier.value.calculateRemainingBalance();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          ValueListenableBuilder<TransactionModel>(
            valueListenable: transactionModelNotifier,
            builder: (context, transactionModel, child) {
              return selectedTab == 0 ? MainpageScreen(transactionModel: transactionModel) : BudgetScreen();
            },
          ),
          bottomNavigation(),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              selectedTab == 0 ? "Expense Tracker" : "Budget",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
              onPressed: widget.onThemeToggle,
              icon: Icon(
                widget.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
            ),
        ],
      ),
      elevation: 0,
    );
  }

  Widget bottomNavigation() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0, top: 30),
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEFF5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 8.0,
                    spreadRadius: 0.5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedTab = 0;  // Switch to Home tab
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_filled,
                              color: selectedTab == 0 ? Colors.blue : Colors.black,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                color: selectedTab == 0 ? Colors.blue : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedTab = 1;  // Switch to Budget tab
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: selectedTab == 1 ? Colors.blue : Colors.black,
                            ),
                            Text(
                              "Budget",
                              style: TextStyle(
                                color: selectedTab == 1 ? Colors.blue : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: InkWell(
              onTap: alertScreen,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 8.0,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void alertScreen() {
    showDialog(context: context, builder: (context) {
      return AddNewScreen(
        expenseScreen: expenseScreen,
        incomeScreen: incomeScreen,
      );
    });
  }

  void expenseScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen(
        descriptionController: descriptionController,
        nameController: nameController,
        amountController: amountController,
        categoryController: categoryController,
        transactionType: "expense",
        transactionFunction: addexpense
    ),),);
  }

  void addexpense() {
    String name = nameController.text.toString();
    String description = descriptionController.text.toString();
    double amount = double.parse(amountController.text.toString());
    String category = categoryController.text.toString();
    String date  =  "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
    setState(() {
      transactionModelNotifier.value.addExpense(
        name,
        description,
        amount,
        category,
        date,
      );
    });
    clearControllers();
    Navigator.pop(context);
  }

  void incomeScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen(
        descriptionController: descriptionController,
        nameController: nameController,
        amountController: amountController,
        categoryController: categoryController,
        transactionType: "income",
        transactionFunction: addincome
    ),),);
  }

  void addincome() {
    String name = nameController.text.toString();
    String description = descriptionController.text.toString();
    double amount = double.parse(amountController.text.toString());
    String category = categoryController.text.toString();
    String date  =  "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
    setState(() {
      transactionModelNotifier.value.addIncome(
        name,
        description,
        amount,
        category,
        date,
      );
    });
    clearControllers();
    Navigator.pop(context);
  }

  void clearControllers() {
    nameController.clear();
    descriptionController.clear();
    categoryController.clear();
    amountController.clear();
  }
}
