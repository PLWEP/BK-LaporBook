import 'package:bk_lapor_book/components/status_dialog.dart';
import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/models/akun.dart';
import 'package:bk_lapor_book/models/laporan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final bool _isLoading = false;
  String? status;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future launch(String uri) async {
    if (uri == '') return;
    if (!await launchUrl(Uri.parse(uri))) {
      throw Exception('Tidak dapat memanggil : $uri');
    }
  }

  Akun akun = Akun(
    uid: '',
    docId: '',
    nama: '',
    noHP: '',
    email: '',
    role: '',
  );

  void getAkun(context) async {
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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void statusDialog(Laporan laporan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatusDialog(
          laporan: laporan,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAkun(context);
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Laporan laporan = arguments['laporan'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
            Text('Detail Laporan', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      laporan.judul,
                      style: headerStyle(level: 3),
                    ),
                    const SizedBox(height: 15),
                    laporan.gambar != ''
                        ? Image.network(laporan.gambar!)
                        : Image.asset('assets/istock-default.jpg'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        laporan.status == 'Posted'
                            ? textStatus('Posted', Colors.yellow, Colors.black)
                            : laporan.status == 'Process'
                                ? textStatus(
                                    'Process', Colors.green, Colors.white)
                                : textStatus('Done', Colors.blue, Colors.white),
                        textStatus(
                            laporan.instansi, Colors.white, Colors.black),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Center(child: Text('Nama Pelapor')),
                      subtitle: Center(child: Text(laporan.nama)),
                      trailing: const SizedBox(width: 45),
                    ),
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: const Center(child: Text('Tanggal Laporan')),
                      subtitle: Center(
                          child: Text(DateFormat('dd MMMM yyyy')
                              .format(laporan.tanggal))),
                      trailing: IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: () {
                          launch(laporan.maps);
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Deskripsi Laporan',
                      style: headerStyle(level: 3),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(laporan.deskripsi ?? ''),
                    ),
                    if (akun.role == 'admin')
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              status = laporan.status;
                            });
                            statusDialog(laporan);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Ubah Status'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Container textStatus(String text, var bgcolor, var textcolor) {
    return Container(
      width: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: bgcolor,
          border: Border.all(width: 1, color: primaryColor),
          borderRadius: BorderRadius.circular(25)),
      child: Text(
        text,
        style: TextStyle(color: textcolor),
      ),
    );
  }
}
