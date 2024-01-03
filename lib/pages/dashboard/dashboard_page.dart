import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/pages/dashboard/all_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/my_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/profile_page.dart';

import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardFull();
}

class _DashboardFull extends State<DashboardPage> {
  int _selectedIndex = 0;

  List<Widget> pages = const <Widget>[
    AllLaporan(),
    MyLaporan(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 35),
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Lapor Book', style: headerStyle(level: 2)),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        selectedFontSize: 16,
        unselectedItemColor: Colors.grey[800],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Semua',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Laporan Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: pages.elementAt(_selectedIndex),
    );
  }
}
