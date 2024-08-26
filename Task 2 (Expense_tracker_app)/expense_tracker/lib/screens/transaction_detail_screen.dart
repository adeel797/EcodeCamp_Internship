import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final String amount;
  final String type;
  final String category;
  final String date;
  TransactionDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Detail"),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leadingWidth: 32,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(500),
              ),
              child: Icon(
                Icons.attach_money_sharp,
                size: 50,
                color: type == 'income' ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 40,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Transaction Name : ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(width: 20,),

                Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Transaction Description : ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(width: 20,),

                Text(description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Transaction Amount : ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(width: 30,),

                Text(amount,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Transaction Category : ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(width: 20,),

                Text(category.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Transaction Type : ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(width: 20,),

                Text(type.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Transaction Date : ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(width: 20,),

                Text(date,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
