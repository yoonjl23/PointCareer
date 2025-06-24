import 'package:flutter/material.dart';
import 'package:pc/screens/Home_screens.dart';
import 'package:pc/screens/Mine_screens.dart';

class NavScreens extends StatefulWidget {
  final String token; // 변경됨
  final int initialIndex;

  const NavScreens({super.key, required this.token, this.initialIndex = 0});

  @override
  State<NavScreens> createState() => _NavScreensState();
}

class _NavScreensState extends State<NavScreens> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  List<Widget> get _screens => [
        HomeScreens(token: widget.token),
        MineScreens(userId: widget.token),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem buildBarItem({
    required IconData icon,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: isSelected ? const Color(0xFF337DFF) : Colors.grey,
        size: 28,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF2F2F2),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          buildBarItem(
            icon: Icons.home_outlined,
            isSelected: _selectedIndex == 0,
          ),
          buildBarItem(
            icon: Icons.person_outline,
            isSelected: _selectedIndex == 1,
          ),
        ],
      ),
    );
  }
}
