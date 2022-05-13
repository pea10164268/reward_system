import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({Key? key}) : super(key: key);

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');
  var setDefaultTeacher = true;
  var teacher;

  String dropdownvalue = 'Select a Class';

  final _classes = [
    'Select a Class',
    'Reception',
    'Year 1',
    'Year 2',
    'Year 3',
    'Year 4',
    'Year 5',
    'Year 6',
  ];

  Future<void> addStudent() {
    return students.add({
      'first_name': _fNameController.text,
      'last_name': _lNameController.text,
      'classroom': dropdownvalue,
      'teacher': teacher,
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
                    controller: _fNameController,
                    decoration: const InputDecoration(
                        hintText: 'First Name*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  TextFormField(
                    controller: _lNameController,
                    decoration: const InputDecoration(
                        hintText: 'Last Name*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  DropdownButton(
                    value: dropdownvalue,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _classes.map((String _classes) {
                      return DropdownMenuItem(
                          value: _classes, child: Text(_classes));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("teachers")
                        .orderBy("last_name")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Loading...");
                      } else {
                        if (setDefaultTeacher) {
                          teacher = snapshot.data!.docs[0].get("last_name");
                          debugPrint("setDefault teacher: $teacher");
                        }
                        return DropdownButton(
                            hint: const Text("Select a Teacher"),
                            isExpanded: true,
                            value: teacher,
                            items: snapshot.data!.docs.map((value) {
                              return DropdownMenuItem(
                                value: value.get('last_name'),
                                child: Text('${value.get('last_name')}'),
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
                      addStudent();
                      const snackBar = SnackBar(
                        content: Text("Student added!"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
