import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/models/akun.dart';
import 'package:bk_lapor_book/pages/dashboard/all_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/my_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardFull();
}

class _DashboardFull extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Akun akun = Akun(
    uid: '',
    docId: '',
    nama: '',
    noHP: '',
    email: '',
    role: '',
  );

  void getAkun(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('akun')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();

        setState(() {
          akun = Akun(
            uid: userData['uid'],
            nama: userData['nama'],
            noHP: userData['noHP'],
            email: userData['email'],
            docId: userData['docId'],
            role: userData['role'],
          );
        });
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getAkun(context);
  }

  @override
  Widget build(BuildContext context) {
    pages = <Widget>[
      AllLaporan(akun: akun),
      MyLaporan(akun: akun),
      Profile(akun: akun),
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 35),
        onPressed: () {
          Navigator.pushNamed(context, '/add', arguments: {'akun': akun});
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : pages.elementAt(_selectedIndex),
    );
  }
}
