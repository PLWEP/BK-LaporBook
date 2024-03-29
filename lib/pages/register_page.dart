import 'package:bk_lapor_book/components/input_widget.dart';
import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/components/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? nama;
  String? email;
  String? noHP;

  final TextEditingController _password = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void register(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference akunCollection = _db.collection('akun');

      final password = _password.text;
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password);

      final docId = akunCollection.doc().id;
      await akunCollection.doc(docId).set({
        'uid': _auth.currentUser!.uid,
        'nama': nama,
        'email': email,
        'noHP': noHP,
        'docId': docId,
        'role': 'masyarakat',
      });

      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
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
                    Text('Register', style: headerStyle(level: 1)),
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputWidget(
                              label: 'Nama',
                              inputField: TextFormField(
                                onChanged: (String value) => setState(() {
                                  nama = value;
                                }),
                                validator: notEmptyValidator,
                                decoration: customInputDecoration(
                                    "Masukan Nama Lengkap"),
                              ),
                            ),
                            InputWidget(
                              label: 'Email',
                              inputField: TextFormField(
                                onChanged: (String value) => setState(() {
                                  email = value;
                                }),
                                validator: notEmptyValidator,
                                decoration: customInputDecoration(
                                    "Masukan Alamat Email"),
                              ),
                            ),
                            InputWidget(
                              label: 'No. Handphone',
                              inputField: TextFormField(
                                onChanged: (String value) => setState(() {
                                  noHP = value;
                                }),
                                validator: notEmptyValidator,
                                decoration: customInputDecoration(
                                    "Masukan Nomor Handphone"),
                              ),
                            ),
                            InputWidget(
                              label: 'Password',
                              inputField: TextFormField(
                                controller: _password,
                                validator: notEmptyValidator,
                                obscureText: true,
                                decoration:
                                    customInputDecoration("Masukan Password"),
                              ),
                            ),
                            InputWidget(
                              label: 'Konfirmasi Password',
                              inputField: TextFormField(
                                validator: (value) =>
                                    passConfirmationValidator(value, _password),
                                obscureText: true,
                                decoration:
                                    customInputDecoration("Masukan Password"),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: FilledButton(
                                style: buttonStyle,
                                child: Text('Register',
                                    style: headerStyle(level: 2)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    register(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}
