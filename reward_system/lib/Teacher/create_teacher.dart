import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateTeacher extends StatefulWidget {
  const CreateTeacher({Key? key}) : super(key: key);

  @override
  State<CreateTeacher> createState() => _CreateTeacherState();
}

class _CreateTeacherState extends State<CreateTeacher> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');

  Future<void> addTeacher() {
    return teachers.add({
      'first_name': _fNameController.text,
      'last_name': _lNameController.text,
      'classroom': dropdownvalue,
    });
  }

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
                  ElevatedButton.icon(
                    onPressed: () {
                      addTeacher();
                      const snackBar = SnackBar(
                        content: Text("Teacher added!"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
