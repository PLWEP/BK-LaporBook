// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bk_lapor_book/common/constant.dart';
import 'package:bk_lapor_book/components/input_widget.dart';
import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/components/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AddFormPage extends StatefulWidget {
  const AddFormPage({super.key});

  @override
  State<StatefulWidget> createState() => AddFormState();
}

class AddFormState extends State<AddFormPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  bool _isLoading = false;

  String? judul;
  String? instansi;
  String? deskripsi;

  ImagePicker picker = ImagePicker();
  XFile? file;

  Future<Position> getCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> uploadImage() async {
    if (file == null) return '';

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference dirUpload =
          _storage.ref().child('upload/${_auth.currentUser!.uid}');
      Reference storedDir = dirUpload.child(uniqueFilename);

      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  void addTransaksi(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('akun')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      final userData = querySnapshot.docs.first.data();
      CollectionReference laporanCollection = _firestore.collection('laporan');

      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      String url = await uploadImage();

      String currentLocation = await getCurrentLocation().then((value) {
        return '${value.latitude},${value.longitude}';
      });

      String maps = 'https://www.google.com/maps/place/$currentLocation';
      final id = laporanCollection.doc().id;

      await laporanCollection.doc(id).set({
        'uid': _auth.currentUser!.uid,
        'docId': id,
        'judul': judul,
        'instansi': instansi,
        'deskripsi': deskripsi,
        'gambar': url,
        'nama': userData['nama'],
        'status': 'Posted',
        'tanggal': timestamp,
        'maps': maps,
      }).catchError((e) {
        throw e;
      });
      Navigator.pop(context);
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
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Tambah Laporan',
          style: headerStyle(level: 3, dark: false),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        InputWidget(
                          label: 'Judul Laporan',
                          inputField: TextFormField(
                            onChanged: (String value) => setState(
                              () {
                                judul = value;
                              },
                            ),
                            validator: notEmptyValidator,
                            decoration: customInputDecoration("Judul laporan"),
                          ),
                        ),
                        if (file != null)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.file(File(file!.path),
                                width: 180, height: 180),
                          ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? upload = await picker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                file = upload;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.photo_camera),
                                const SizedBox(width: 10),
                                Text(
                                  'Foto Pendukung',
                                  style: headerStyle(level: 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InputWidget(
                          label: 'Instansi',
                          inputField: DropdownButtonFormField<String>(
                            decoration: customInputDecoration('Instansi'),
                            items: Constants.dataInstansi.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            onChanged: (selected) => setState(() {
                              instansi = selected;
                            }),
                          ),
                        ),
                        InputWidget(
                          label: "Deskripsi Lengkap",
                          inputField: TextFormField(
                            onChanged: (String value) => setState(() {
                              deskripsi = value;
                            }),
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 5,
                            decoration: customInputDecoration(
                                'Deskripsikan semua di sini'),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: buttonStyle,
                            onPressed: () {
                              addTransaksi(context);
                            },
                            child: Text(
                              'Kirim Laporan',
                              style: headerStyle(level: 3, dark: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
