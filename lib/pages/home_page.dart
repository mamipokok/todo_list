import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_list/constants/custom_color.dart';
import 'package:todo_list/db/DatabaseHelper.dart';
import 'package:todo_list/model/task_models.dart';
import 'package:todo_list/pages/add_task_page.dart';
import 'package:todo_list/pages/edit_task_page.dart';
import 'package:todo_list/widget/delete_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _TryState();
}

class _TryState extends State<HomePage> {
  late List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final fetchedTasks = await DatabaseHelper().getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  double _calculateProgress() {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task.completed == 1).length;
    return completedTasks / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.warna4,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Container(
                height: 40,
                width: 170,
                decoration: BoxDecoration(
                  color: CustomColor.warna2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "T O D O L I S T",
                    style: TextStyle(
                      color: CustomColor.warna1,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              expandedHeight: 200,
              centerTitle: true,
              floating: true,
              pinned: true,
              backgroundColor: CustomColor.warna1,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 30.0,
                                lineWidth: 5.0,
                                animation: true,
                                percent: _calculateProgress(),
                                center: Text(
                                  "${(_calculateProgress() * 100).toInt()}%",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.warna3,
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: CustomColor.warna2,
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tugas Saya",
                                    style: TextStyle(
                                      color: CustomColor.warna4,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    "Atur Jadwalmu",
                                    style: TextStyle(
                                      color: CustomColor.warna3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: CustomColor.warna2,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColor.warna1,
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                activeColor: CustomColor.warna1,
                                side: BorderSide(
                                  color: CustomColor.warna1,
                                  width: 3,
                                  strokeAlign: 1,
                                ),
                                value: task.completed == 1,
                                onChanged: (bool? value) async {
                                  task.completed = value == true ? 1 : 0;
                                  await DatabaseHelper().updateTask(task);
                                  _loadTasks();
                                },
                              ),
                              Text(
                                task.title,
                                style: TextStyle(
                                  color: CustomColor.warna1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 6, 97, 97),
                                      radius: 20,
                                      child: IconButton(
                                        onPressed: () async {
                                          final updatedTask =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditTaskPage(task: task),
                                            ),
                                          );
                                          if (updatedTask != null) {
                                            await DatabaseHelper()
                                                .updateTask(updatedTask);
                                            _loadTasks();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: CustomColor.warna2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    CircleAvatar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 126, 4, 4),
                                      radius: 20,
                                      child: IconButton(
                                        onPressed: () async {
                                          final shouldDelete =
                                              await showDeleteConfirmationDialog(
                                                  context);
                                          if (shouldDelete == true &&
                                              task.id != null) {
                                            await DatabaseHelper()
                                                .deleteTask(task.id!);
                                            _loadTasks();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: CustomColor.warna2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color:
                                          getColorFromPriority(task.priority),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: CustomColor.warna1,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 2, 58, 3),
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Mulai : ${task.startDate}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 140,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 77, 4, 4),
                                        // borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "sampai : ${task.endDate}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColor.warna1,
          onPressed: () async {
            final newTask = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage()),
            );
            if (newTask != null) {
              _loadTasks();
            }
          },
          child: Icon(
            Icons.add_circle,
            color: CustomColor.warna2,
          ),
        ),
      ),
    );
  }
}

Color getColorFromPriority(String priority) {
  switch (priority) {
    case 'High':
      return const Color.fromARGB(255, 255, 17, 0); // merah
    case 'Medium':
      return const Color.fromARGB(255, 254, 155, 5); // oranye
    case 'Low':
    default:
      return const Color.fromARGB(255, 0, 255, 13); // hijau
  }
}
