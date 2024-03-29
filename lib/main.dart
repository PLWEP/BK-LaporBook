import 'package:bk_lapor_book/firebase_options.dart';
import 'package:bk_lapor_book/pages/dashboard/add_form_page.dart';
import 'package:bk_lapor_book/pages/dashboard/dashboard_page.dart';
import 'package:bk_lapor_book/pages/detail_page.dart';
import 'package:bk_lapor_book/pages/login_page.dart';
import 'package:bk_lapor_book/pages/notconnect_page.dart';
import 'package:bk_lapor_book/pages/register_page.dart';
import 'package:bk_lapor_book/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lapor Book',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/add': (context) => const AddFormPage(),
          '/detail': (context) => const DetailPage(),
          '/notconnect': (context) => const NotConnectPage(),
        },
      ),
    ),
  );
}
