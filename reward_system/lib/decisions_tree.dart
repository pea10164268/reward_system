import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reward_system/Login/login_screen.dart';
import 'package:reward_system/Tabs/Tabs.dart';

class DecisionTree extends StatefulWidget {
  const DecisionTree({Key? key}) : super(key: key);

  @override
  State<DecisionTree> createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  User? user;
  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const LoginScreen();
    } else {
      return const TabsScreen();
    }
  }
}
