import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/utilities/todo_structure.dart';
import '../database/database_file.dart';

class Homepage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  bool isDarkMode;

  Homepage({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController textController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool isVissible = false;
  DatabaseFile db = DatabaseFile();
  String selectedTab = "All";
  List<List<dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    var box = Hive.box("todoData");
    if (box.get("todolist") == null) {
      db.loadData();
    } else {
      db.getData();
    }
    filteredList = db.todolist;

    searchController.addListener(() {
      _filterTasks(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    textController.dispose();
    super.dispose();
  }

  void _filterTasks(String query) {
    List<List<dynamic>> filter = [];
    if (query.isEmpty) {
      filter = db.todolist;
    } else {
      filter = db.todolist
          .where((task) => task[0].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredList = filter;
    });
  }

  // Toggle visibility of the task input area
  void vissible() {
    setState(() {
      isVissible = !isVissible;

      if (!isVissible) {
        // Clear the search text when search bar is closed
        searchController.clear();
        // Reset the filtered list to show all tasks according to the selected tab
        _applyFilters();
      }
    });
  }


  // Toggle the completion status of a task
  void onClickCheckbox(bool? value, int index) {
    setState(() {
      db.todolist[index][1] = !db.todolist[index][1];
    });
    db.updateData();
    _applyFilters(); // Apply filters after updating the checkbox state
  }

  void _applyFilters() {
    List<List<dynamic>> filter = db.todolist;

    // Apply search filter
    if (searchController.text.isNotEmpty) {
      filter = filter
          .where((task) => task[0].toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    }

    // Apply tab filter
    if (selectedTab == "Undone") {
      filter = filter.where((task) => !task[1]).toList();
    } else if (selectedTab == "Done") {
      filter = filter.where((task) => task[1]).toList();
    }

    setState(() {
      filteredList = filter;
    });
  }


  // Delete a task from the list
  void deleteTask(int index) {
    setState(() {
      db.todolist.removeAt(index);
    });
    db.updateData();
    _filterTasks(searchController.text); // Update the filter after a task is deleted
  }

  // Save a new task to the list
  void savetask() {
    setState(() {
      db.addTask(textController.text);
      textController.clear();
    });
    db.updateData();
    _filterTasks(searchController.text); // Update the filter after a task is added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Main content of the page (tabs and to-do list)
          mainpage(),
          // Input area for adding new tasks
          addnewtask(),
        ],
      ),
    );
  }

  // Custom AppBar widget with a title and theme toggle button
  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "ToDo Lists",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: vissible,
            icon: Icon(
              isVissible ? Icons.search_off : Icons.search,
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

  // Widget to display the search bar of to-do items based on the search icon
  Widget searchbar(BuildContext context) {
    return Visibility(
      visible: isVissible,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8,right: 8.0,left: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: searchController,
          keyboardType: TextInputType.text,
          cursorColor: Theme.of(context).colorScheme.primary,
          autocorrect: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 20,
              maxWidth: 25,
            ),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  // Tab layout widget to switch between different views (All, Undone, Done)
  Widget tablayout() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(left: 8.0,right: 8.0),
      height: 60,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedTab = "All";
              });
              _applyFilters();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: selectedTab == "All" ? Theme.of(context).colorScheme.secondary : Colors.transparent,
              ),
              child: Text(
                "All",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selectedTab = "Undone";
              });
              _applyFilters();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: selectedTab == "Undone" ? Theme.of(context).colorScheme.secondary : Colors.transparent,
              ),
              child: Text(
                "Undone",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selectedTab = "Done";
              });
              _applyFilters();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: selectedTab == "Done" ? Theme.of(context).colorScheme.secondary : Colors.transparent,
              ),
              child: Text(
                "Done",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display the list of to-do items based on the selected tab
  Widget list_todo() {
    if (filteredList.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 250),
          child: Text(
            "No items to display",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return TodoStructure(
            taskName: filteredList[index][0],
            CheckValue: filteredList[index][1],
            onChange: (value) => onClickCheckbox(value, db.todolist.indexOf(filteredList[index])),
            delFunction: () => deleteTask(db.todolist.indexOf(filteredList[index])),
          );
        },
      ),
    );
  }

  // Widget to handle the input of new tasks
  Widget addnewtask() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 30,
                right: 20,
                left: 30,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
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
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add a new task",
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: savetask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                minimumSize: const Size(60, 60),
                elevation: 10,
              ),
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display the main content of the page (tabs, search bar, and to-do list)
  Widget mainpage() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          searchbar(context),
          tablayout(),
          list_todo(),
        ],
      ),
    );
  }
}
