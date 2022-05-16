import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateTeacher extends StatefulWidget {
  const CreateTeacher({Key? key}) : super(key: key);

  @override
  State<CreateTeacher> createState() => _CreateTeacherState();
}

class _CreateTeacherState extends State<CreateTeacher> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');

  Future<void> addTeacher() {
    return teachers.add({
      'full_name': _fullNameController.text,
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
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Success!"),
                                content: const Text("New teacher added"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(
                                          context, '/teacher/add'),
                                      child: const Text('Ok')),
                                ],
                              );
                            });
                        addTeacher();
                      }
                    },
                    icon: const Icon(
                      Icons.person_add_alt_rounded,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Add Teacher",
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
          title: const Text('Add a teacher',
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
