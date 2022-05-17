// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:reward_system/Tabs/Stars/create_star.dart';
import 'Profile/profile_screen.dart';
import 'Leaderboard/leaderboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final _auth = FirebaseAuth.instance;

  int _selectedIndex = 1;

  final List<Map<String, Widget>> pages = [
    {
      'page': const Leaderboard(),
    },
    {
      'page': const ProfileScreen(),
    },
    {
      'page': const CreateStar(),
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: _auth.currentUser!.displayName,
            backgroundColor: Colors.blue,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/star/add');
          }),
    );
  }
}
