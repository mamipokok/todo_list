import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/constants/custom_color.dart';
import 'package:todo_list/db/DatabaseHelper.dart';
import 'package:todo_list/model/task_models.dart';
import 'package:todo_list/widget/custom_textfield.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _TryState();
}

class _TryState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>(); // Key untuk Form
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String _priority = "Low";
  String? nul;

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDate = DateFormat('dd MMM, HH:mm').format(fullDateTime);
        setState(() {
          controller.text = formattedDate;
        });
      }
    }
  }

  int colorToHex(String color) {
    switch (color.toLowerCase()) {
      case 'low':
        return 0xFFFBCF84;
      case 'medium':
        return 0xFFDDB26A;
      case 'high':
        return 0xFF172B4D;
      default:
        return 0xFF000000;
    }
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      int colorHex = colorToHex(_priority);
      Task newTask = Task(
        title: _titleController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        priority: _priority,
        completed: 0,
        color: colorHex.toRadixString(16).padLeft(8, '0'),
      );

      await DatabaseHelper().insertTask(newTask);
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.warna4,
      appBar: AppBar(
        backgroundColor: CustomColor.warna1,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: CustomColor.warna3,
          ),
        ),
        title: Text(
          "Tambah Tugas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: CustomColor.warna3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(
                    style: BorderStyle.none,
                  )),
            ),
            SizedBox(height: 78),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _titleController,
                      ReadOnly: false,
                      hintText: "Nama",
                    ),
                    SizedBox(height: 6),
                    CustomTextfield(
                      controller: _startDateController,
                      hintText: "Mulai",
                      ReadOnly: true,
                      fungsi: () => _selectDateTime(_startDateController),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Start Date must be filled in";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    CustomTextfield(
                      controller: _endDateController,
                      hintText: "sampai",
                      ReadOnly: true,
                      fungsi: () => _selectDateTime(_endDateController),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Start Date must be filled in";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: CustomColor.warna1,
                      ),
                      hint: Text(
                        "Prioritas",
                        style: TextStyle(
                          color: CustomColor.warna1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: nul,
                      items: ["Low", "Medium", "High"].map((priority) {
                        Color bgColor;
                        Color textColor = Colors.black;

                        switch (priority) {
                          case "Low":
                            textColor = CustomColor.warna3;
                            bgColor = const Color.fromARGB(255, 9, 128, 15);
                            break;
                          case "Medium":
                            bgColor = const Color.fromARGB(255, 161, 100, 9);
                            textColor = CustomColor.warna3;
                            break;
                          case "High":
                            bgColor = const Color.fromARGB(255, 137, 21, 21);
                            textColor = CustomColor.warna3;
                            break;
                          default:
                            bgColor = Colors.grey;
                        }

                        return DropdownMenuItem<String>(
                          value: priority,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              priority,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _priority = newValue!;
                        });
                      },
                      dropdownColor: CustomColor.warna1,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 159, 118, 47),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.warna1,
                      ),
                      onPressed: _addTask,
                      child: Text(
                        "T A M B A H",
                        style: TextStyle(
                          color: CustomColor.warna3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
