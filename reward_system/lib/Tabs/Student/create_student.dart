// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({Key? key}) : super(key: key);

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  CollectionReference classrooms =
      FirebaseFirestore.instance.collection('classrooms');
  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');
  var setDefaultTeacher = true;
  var setDefaultClassroom = true;
  var teacher;
  var classroom;

  Future<void> addStudent() {
    return students.add({
      'full_name': _fullNameController.text,
      'class_name': classroom,
      'teacher': teacher,
      'no_of_stars': 0,
    });
  }

  Widget form() {
    return Expanded(
      child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                        hintText: 'Full Name*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name.';
                      }
                      return null;
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("classrooms")
                        .orderBy("class_name")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Loading...");
                      } else {
                        if (setDefaultClassroom) {
                          classroom = snapshot.data!.docs[0].get("class_name");
                          debugPrint("setDefault classroom: $classroom");
                        }
                        return DropdownButton(
                            isExpanded: true,
                            value: classroom,
                            items: snapshot.data!.docs.map((value) {
                              return DropdownMenuItem(
                                value: value.get('class_name'),
                                child: Text('${value.get('class_name')}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              debugPrint("selected onchange: $value");
                              setState(() {
                                debugPrint("classroom selected: $value");
                                classroom = value;
                                setDefaultClassroom = false;
                              });
                            });
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("classrooms")
                        .where('class_name', isEqualTo: classroom)
                        .orderBy("teacher")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Loading...");
                      } else {
                        if (setDefaultTeacher) {
                          teacher = snapshot.data!.docs[0].get("teacher");
                          debugPrint("setDefault teacher: $teacher");
                        }
                        return DropdownButton(
                            isExpanded: false,
                            value: teacher,
                            items: snapshot.data!.docs.map((value) {
                              return DropdownMenuItem(
                                value: value.get('teacher'),
                                child: Text(
                                  '${value.get('teacher')}',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              debugPrint("selected onchange: $value");
                              setState(() {
                                debugPrint("teacher selected: $value");
                                teacher = value;
                                setDefaultTeacher = false;
                              });
                            });
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Success!"),
                                content:
                                    Text("New student added to $classroom!"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(
                                          context, '/student/add'),
                                      child: const Text('Ok')),
                                ],
                              );
                            });
                        addStudent();
                      }
                    },
                    icon: const Icon(
                      Icons.person_add_alt_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Add Student",
                    ),
                  )
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a student',
              style: TextStyle(
                fontSize: 20,
              )),
        ),
        body: Center(
          child: Column(children: [
            form(),
          ]),
        ));
  }
}
