// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  var setDefaultClassroom = true;
  var classroom;
  var setDefaultStudent = true;
  var student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Divider(thickness: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("students")
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
                        isExpanded: false,
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
                        isExpanded: false,
                        value: student,
                        items: snapshot.data!.docs.map((value) {
                          return DropdownMenuItem(
                            value: value.get('full_name'),
                            child: Text(
                              '${value.get('full_name')}',
                            ),
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
            ],
          ),
          const Divider(thickness: 4),
          Center(
              child: Column(
            children: [
              StreamBuilder(
                stream: students.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data!.docs[index]['full_name']),
                        subtitle:
                            Text(snapshot.data?.docs[index]['class_name']),
                        trailing: Text(snapshot.data?.docs[index]['teacher']),
                      );
                    },
                  );
                },
              ),
            ],
          )),
        ],
      )),
    );
  }
}
