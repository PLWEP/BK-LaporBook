import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  final auth = FirebaseAuth.instance;

  Future<bool> checkConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    super.initState();
    User? user = auth.currentUser;
    checkConnection().then((value) {
      if (value == false) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/notconnect');
        });
      }
    });

    if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Selamat datang di Aplikasi Laporan'),
        ),
      ),
    );
  }
}
