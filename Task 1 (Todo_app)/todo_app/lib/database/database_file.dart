import 'package:hive_flutter/hive_flutter.dart';

class DatabaseFile {
  // This list stores the to-do list items. Each item is a list containing
  // two elements: the task description (String) and a boolean indicating if the task is done.
  List<List<dynamic>> todolist = [];

  // Reference to the Hive box named "todoData".
  // This box is used for persisting the to-do list data.
  final box = Hive.box("todoData");

  // Updates the Hive box with the current state of the to-do list.
  // This method should be called after any change to the list (e.g., adding or removing a task).
  void updateData() {
    box.put("todolist", todolist);
  }

  // Initializes the `todolist` with default data (currently an empty list).
  // Calls `updateData` to ensure the Hive box is updated with this initial state.
  void loadData() {
    todolist = [];
    updateData();
  }

  // Retrieves the to-do list data from the Hive box.
  // Converts the data back to a List<List<dynamic>> type.
  void getData() {
    var data = box.get("todolist");
    if (data != null) {
      todolist = List<List<dynamic>>.from(data);
    }
  }

  // Adds a new task to the top of the list and updates the data in Hive.
  void addTask(String taskName) {
    todolist.insert(0, [taskName, false]);
    updateData();
  }
}
