import 'package:flutter/material.dart';

// A StatelessWidget to represent a to-do item structure.
class TodoStructure extends StatelessWidget {
  final String taskName;
  final bool CheckValue;
  Function(bool?)? onChange;
  final VoidCallback delFunction;

  // Constructor to initialize the variables and functions for this widget.
  TodoStructure({
    super.key,
    required this.taskName,
    required this.CheckValue,
    required this.onChange,
    required this.delFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0,top: 8.0),
      child: InkWell(
        onTap: (){
          onChange?.call(!CheckValue);
        },
        child: Container(
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.only(right: 8.0,left: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            // Row widget to arrange the checkbox, task name, and delete button horizontally.
            children: [
              Checkbox(
                value: CheckValue,
                onChanged: onChange,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              // Expanded widget ensures the task name takes up all available space.
              Expanded(
                child: Text(
                  taskName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    decoration: CheckValue ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ),
              // IconButton to create a delete button on the right side.
              IconButton(
                onPressed: delFunction,
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
