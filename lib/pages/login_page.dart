import 'package:flutter/material.dart';
import '../components/input_widget.dart';
import '../components/styles.dart';
import '../components/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  String? email;
  String? password;

  void login(context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        ModalRoute.withName('/dashboard'),
      );
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Text('Login', style: headerStyle(level: 2)),
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputWidget(
                              label: 'Email',
                              inputField: TextFormField(
                                onChanged: (String value) => setState(() {
                                  email = value;
                                }),
                                validator: notEmptyValidator,
                                decoration: customInputDecoration("Email"),
                              ),
                            ),
                            InputWidget(
                              label: 'Password',
                              inputField: TextFormField(
                                onChanged: (String value) => setState(() {
                                  password = value;
                                }),
                                validator: notEmptyValidator,
                                obscureText: true,
                                decoration: customInputDecoration("Password"),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: FilledButton(
                                style: buttonStyle,
                                child: Text('Login',
                                    style: headerStyle(level: 3, dark: false)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    login(context);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Dont have an account? '),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
