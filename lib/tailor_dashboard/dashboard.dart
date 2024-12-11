import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/tailor_dashboard/about_me.dart';
import 'package:fyp/tailor_dashboard/chats.dart';

class TailorDashboard extends StatefulWidget {
  const TailorDashboard({super.key});

  @override
  State<TailorDashboard> createState() => _TailorDashboardState();
}

class _TailorDashboardState extends State<TailorDashboard> {
  int selectedIndex = 0;

  void onChangeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final _bodies = const [ChatsView(), AboutMe()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            selectedIndex == 0 ? "Chats" : "About me",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        leadingWidth: MediaQuery.sizeOf(context).width,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: _bodies,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person), label: "About me"),
        ],
        onTap: onChangeIndex,
      ),
    );
  }
}
