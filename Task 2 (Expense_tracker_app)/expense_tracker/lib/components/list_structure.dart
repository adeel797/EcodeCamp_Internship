import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../screens/transaction_detail_screen.dart';

class ListStructure extends StatelessWidget {
  final String taskName;
  final String description;
  final String amount;
  final String type;
  final String category;
  final String date;
  final VoidCallback onDelete;

  ListStructure({
    super.key,
    required this.taskName,
    required this.amount,
    required this.type,
    required this.description,
    required this.category,
    required this.date,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'delete',
              spacing: 0,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(
                  name: taskName,
                  description: description,
                  amount: amount,
                  type: type,
                  category: category,
                  date: date,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(
                top: 16.0, right: 16.0, bottom: 16.0, left: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: Icon(
                    Icons.attach_money_sharp,
                    size: 30,
                    color: type == 'income' ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    taskName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  type == 'income' ? "+ $amount" : "- $amount",
                  style: TextStyle(
                    color: type == 'income' ? Colors.green : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
