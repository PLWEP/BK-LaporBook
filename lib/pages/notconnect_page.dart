import 'package:flutter/material.dart';

class NotConnectPage extends StatelessWidget {
  const NotConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off),
              Text("Please Connect To Internet And Reopen Application"),
            ],
          ),
        ),
      ),
    );
  }
}
