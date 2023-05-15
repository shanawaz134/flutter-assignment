import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/constants.dart';
import 'package:flutter_assignment/login.dart';
import 'package:intl/intl.dart';

import 'package:flutter_assignment/mainscreen.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final List<String> _category = ['Personal', 'Business']; // Option 2
  String? _selectedCategory;
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('dd MMM yyyy');
        final String formatted = formatter.format(selectedDate);
        dateController.text = formatted;
      });
    }
  }

  @override
  void initState() {
    if(task != null){
      taskController.text = task!.task.toString();
      dateController.text = task!.date.toString();
      descController.text = task!.description.toString();
      _selectedCategory = task!.category.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    taskController.dispose();
    dateController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.color,
      appBar: AppBar(
        backgroundColor: AppColor.color,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: appText(task != null ? 'Update Task' : 'Add New Task'),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_sharp, size: 40, color: Colors.blue,),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2)
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.edit_outlined, size: 40, color: Colors.blue,)
                  ),
                ),
              ),
              appDropdown(),
              appTextField(taskController, 'Task Name', 'task'),
              appTextField(dateController, 'Select Date', 'date'),
              appTextField(descController, 'Add description', 'desc'),

              Container(
                margin: const EdgeInsets.only(top: 25),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: (){
                    if(taskController.text.isNotEmpty && descController.text.isNotEmpty
                        && dateController.text.isNotEmpty){
                      final d = {
                        'task': taskController.text,
                        'desc': descController.text,
                        'date': dateController.text,
                        'status': task == null ? 'New Task' : 'updated task',
                        'crested_at': DateTime.now().toString(),
                        'category': _selectedCategory
                      };
                      onPress(d);
                    }else{
                      showInSnackBar(context, 'Please enter all the fields');
                    }
                  },
                  child: appText(task == null ? 'Submit' : 'update')
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appDropdown(){
    return DropdownButton(
      isExpanded: true,
      dropdownColor: Colors.blue,
      iconSize: 40,
      iconEnabledColor: Colors.grey,
      hint: appText('Category'),
      style: const TextStyle(
          color: Colors.white,
          fontSize: 18
      ),// Not necessary for Option 1
      value: _selectedCategory,
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue as String?;
        });
      },
      items: _category.map((location) {
        return DropdownMenuItem(
          child: Text(location),
          value: location,
        );
      }).toList(),
    );
  }

  onPress(Map<String, dynamic> data) async{
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    String col = user!.email;
    if(task == null){
      final result = await _fireStore.collection(col).add(data);
      await result.update({'id': result.id});
    }else{
      await _fireStore.collection(col).doc(task!.id).update(data);
    }
    Navigator.pop(context);
  }

  Widget appTextField(TextEditingController controller, String hint, String type){
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: TextField(
        controller: controller,
        readOnly: type == 'date' ? true : false,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        onTap: type == 'date' ? () {
          _selectDate(context);
        } : null,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.white),
          hintText: hint,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.3),
            // borderRadius: BorderRadius.circular(25.7),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.3),
            // borderRadius: BorderRadius.circular(25.7),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.3),
            // borderRadius: BorderRadius.circular(25.7),
          ),
        ),
      ),
    );
  }

  Widget appText(String text){
    return Text(
      text,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white
      ),
    );
  }
}

