import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateClassroom extends StatefulWidget {
  const CreateClassroom({Key? key}) : super(key: key);

  @override
  State<CreateClassroom> createState() => _CreateClassroomState();
}

class _CreateClassroomState extends State<CreateClassroom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _classNameController = TextEditingController();
  CollectionReference classrooms =
      FirebaseFirestore.instance.collection('classrooms');
  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');
  var setDefaultTeacher = true;
  // ignore: prefer_typing_uninitialized_variables
  var teacher;

  Future<void> createClassroom() {
    return classrooms.add({
      'class_name': _classNameController.text,
      'teacher': teacher,
    });
  }

  @override
  void dispose() {
    _classNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Classroom',
              style: TextStyle(
                fontSize: 20,
              )),
        ),
        body: Center(
          child: Column(children: [
            Expanded(
              child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _classNameController,
                            decoration: const InputDecoration(
                                hintText: 'Classroom Name*',
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a classroom name.';
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Teachers Name*  ',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("teachers")
                                    .orderBy("full_name")
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text("Loading...");
                                  } else {
                                    if (setDefaultTeacher) {
                                      teacher = snapshot.data!.docs[0]
                                          .get("full_name");
                                      debugPrint(
                                          "setDefault teacher: $teacher");
                                    }
                                    return DropdownButton(
                                        value: teacher,
                                        items: snapshot.data!.docs.map((value) {
                                          return DropdownMenuItem(
                                            value: value.get('full_name'),
                                            child: Text(
                                                '${value.get('full_name')}'),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          debugPrint(
                                              "selected onchange: $value");
                                          setState(() {
                                            debugPrint(
                                                "teacher selected: $value");
                                            teacher = value;
                                            setDefaultTeacher = false;
                                          });
                                        });
                                  }
                                },
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Success!"),
                                        content: Text(
                                            "New classroom added! with $teacher as the teacher!"),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, '/tabs'),
                                              child: const Text('Ok')),
                                        ],
                                      );
                                    });
                                createClassroom();
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Add Classroom",
                            ),
                          )
                        ],
                      ))),
            ),
          ]),
        ));
  }
}
