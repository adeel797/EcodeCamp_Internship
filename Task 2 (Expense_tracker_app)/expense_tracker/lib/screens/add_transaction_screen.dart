import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  final TextEditingController descriptionController;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final TextEditingController categoryController;
  final String transactionType;
  final VoidCallback transactionFunction;
  AddTransactionScreen({super.key,
    required this.descriptionController,
    required this.nameController,
    required this.amountController,
    required this.categoryController,
    required this.transactionType,
    required this.transactionFunction
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  List<String> categoryList = [];

  List<String> incomeList = [
    'Salary',
    'Business',
    'Investment',
    'Gift',
    'Other',
  ];

  List<String> expenseList = [
    'Foods',
    'Transportation',
    'Communication',
    'Housing',
    'Personal Care',
    'Health and Wellness',
    'Education',
    'Entertainment',
    'Debt Payments',
    'Pets',
    'Others'
  ];

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize the category list based on the transaction type
    categoryList = widget.transactionType == 'expense' ? expenseList : incomeList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.transactionType.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              keyboardType: TextInputType.text,
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              keyboardType: TextInputType.text,
              controller: widget.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              keyboardType: TextInputType.number,
              controller: widget.amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),

            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              value: widget.categoryController.text.isEmpty
                  ? null
                  : widget.categoryController.text,
              items: categoryList.map((String category){
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  widget.categoryController.text = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
            const SizedBox(height: 30),
            button()
          ],
        ),
      ),
    );
  }

  Widget button() {
    return OutlinedButton(
      onPressed: () {
        if (widget.amountController.text.isEmpty || widget.nameController.text.isEmpty || widget.categoryController.text.isEmpty) {
          print("ERROR");
        } else {

          widget.transactionFunction();
        }
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFEEEFF5),
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
      ),
      child: Text(
        widget.transactionType == 'income' ? 'Add Income' : 'Add Expense',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
