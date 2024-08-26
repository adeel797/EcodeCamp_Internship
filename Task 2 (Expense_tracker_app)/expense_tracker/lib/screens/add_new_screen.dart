import 'package:flutter/material.dart';

class AddNewScreen extends StatelessWidget {
  final VoidCallback expenseScreen;
  final VoidCallback incomeScreen;

  AddNewScreen({
    super.key,
    required this.expenseScreen,
    required this.incomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Container(
          width: 350,
          height: 200, // Increased height to accommodate the date picker
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add a New:",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button("Income", incomeScreen,context),
                  const SizedBox(
                    width: 16,
                  ),
                  button("Expense", expenseScreen,context),
                ],
              ),
            ],
          )),
    );
  }

  Widget button(String btnname, VoidCallback function,BuildContext context) {
    return OutlinedButton(
      onPressed: (){
        Navigator.pop(context);
        function();
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFEEEFF5),
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      child: Text(
        btnname,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
