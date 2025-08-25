import 'package:cima_optimizer/shared/widgets/gradient_title.dart';
import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../knowledge_hub/knowledge_hub_screen.dart';
import '../practice/practice_screen.dart';
import '../profile/screens/profile_screen.dart'; // I need to import my new screen.

final mainScreenKey = GlobalKey<_MainScreenState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // I'm adding my new ProfileScreen to the list of widgets.
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    KnowledgeHubScreen(),
    PracticeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GradientTitle(),
        centerTitle: true,
        // The old logout button is no longer needed here.
        actions: const [],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        // I need to set the type to fixed to handle four items.
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Knowledge'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Practice'),
          // I'm adding the new Profile tab item.
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
