// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateStar extends StatefulWidget {
  const CreateStar({Key? key}) : super(key: key);

  @override
  State<CreateStar> createState() => _CreateStarState();
}

class _CreateStarState extends State<CreateStar> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');
  CollectionReference classrooms =
      FirebaseFirestore.instance.collection('classrooms');
  final TextEditingController _descriptionController = TextEditingController();
  var setDefaultStudent = true;
  var student;
  var setDefaultTeacher = true;
  var teacher;
  var setDefaultClassroom = true;
  var classroom;
  final CollectionReference<Map<String, dynamic>> coll =
      FirebaseFirestore.instance.collection("students");

  @override
  void dispose() {
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> addStar() async {
    FirebaseFirestore.instance.collection("student").add({
      'full_name': student,
      'description': _descriptionController.text,
      'class_achieved': classroom,
      'awarded_by': teacher,
      'no_of_stars': FieldValue.increment(1),
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("classrooms")
                        .orderBy('class_name')
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("students")
                        .where('class_name', isEqualTo: classroom)
                        .orderBy("full_name")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Loading...");
                      } else {
                        if (setDefaultStudent) {
                          student = snapshot.data!.docs[0].get("full_name");
                          debugPrint("setDefault student: $student");
                        }
                        return DropdownButton(
                            isExpanded: true,
                            value: student,
                            items: snapshot.data!.docs.map((value) {
                              return DropdownMenuItem(
                                value: value.get('full_name'),
                                child: Text('${value.get('full_name')}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              debugPrint("selected onchange: $value");
                              setState(() {
                                debugPrint("student selected: $value");
                                student = value;
                                setDefaultStudent = false;
                              });
                            });
                      }
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Description*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description.';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Well Done!"),
                                content:
                                    Text("Keep up the good work, $student!"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(
                                          context, '/student/add'),
                                      child: const Text('Ok')),
                                ],
                              );
                            });
                        addStar();
                      }
                    },
                    icon: const Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Award Star",
                    ),
                  )
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Award a star',
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
