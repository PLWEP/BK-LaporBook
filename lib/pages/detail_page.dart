import 'dart:math';

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
  TextEditingController commentController = TextEditingController();

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
        actions: [
          FutureBuilder(
            future: getLikedData(laporan.docId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                );
              } else {
                bool isLikedByCurrentUser = false;
                if (snapshot.data!.isNotEmpty) {
                  for (Like like in snapshot.data!) {
                    if (like.uid == FirebaseAuth.instance.currentUser!.uid) {
                      isLikedByCurrentUser = true;
                      break;
                    }
                  }
                }
                return GestureDetector(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            isLikedByCurrentUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                isLikedByCurrentUser ? Colors.red : Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    await saveLikeData(laporan.docId);
                    setState(() {});
                  },
                );
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading
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
                      Text(
                        laporan.judul,
                        style: headerStyle(level: 3),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                laporan.gambar != ''
                                    ? Image.network(laporan.gambar!)
                                    : Image.asset('assets/istock-default.jpg'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          laporan.status == 'Posted'
                              ? textStatus(
                                  'Posted', Colors.yellow, Colors.black)
                              : laporan.status == 'Process'
                                  ? textStatus(
                                      'Process', Colors.green, Colors.white)
                                  : textStatus(
                                      'Done', Colors.blue, Colors.white),
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
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Komentar',
                            style: headerStyle(level: 3),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<List<Komentar>>(
                            future: getCommentsData(laporan.docId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text('Tidak ada komentar.');
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Komentar comment = snapshot.data![index];
                                    return ListTile(
                                      title: Text(comment.nama),
                                      subtitle: Text(comment.isi),
                                      trailing: Text(
                                        DateFormat('dd MMM yyyy HH:mm')
                                            .format(comment.waktu),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'Tambahkan komentar...',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () async {
                                  await addComment(laporan.docId);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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

  Future<void> saveLikeData(String docId) async {
    try {
      CollectionReference laporanCollection =
          FirebaseFirestore.instance.collection('laporan');

      final uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot likeDoc =
          await laporanCollection.doc(docId).collection('likes').doc(uid).get();

      String likeId = DateTime.now().toIso8601String() +
          Random().nextInt(10000000).toString();

      if (!likeDoc.exists) {
        await laporanCollection.doc(docId).collection('likes').doc(uid).set({
          'uid': uid,
          'timestamp': FieldValue.serverTimestamp(),
          'likeid': likeId
        });
      } else {
        await laporanCollection
            .doc(docId)
            .collection('likes')
            .doc(uid)
            .delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving like data: $e');
      }
    }

    await getLikedData(docId);
  }

  Future<void> addComment(String docId) async {
    try {
      CollectionReference laporanCollection =
          FirebaseFirestore.instance.collection('laporan');

      String commentText = commentController.text.trim();
      String commentId = DateTime.now().toIso8601String() +
          Random().nextInt(10000000).toString();

      await laporanCollection
          .doc(docId)
          .collection('comments')
          .doc(commentId)
          .set({
        'uid_akun': akun.uid,
        'nama': akun.nama,
        'comment': commentText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Komentar berhasil ditambahkan'),
        ),
      );

      commentController.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding comment: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan. Gagal menambahkan komentar.'),
        ),
      );
    }
  }

  Future<List<Like>> getLikedData(String docId) async {
    try {
      QuerySnapshot likeSnapshot = await FirebaseFirestore.instance
          .collection('laporan')
          .doc(docId)
          .collection('likes')
          .get();

      List<Like> like = likeSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Like(
          waktu: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          uid: data['uid'] ?? '',
          likeid: data['uidLaporan'] ?? '',
        );
      }).toList();

      return like;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting comments data: $e');
      }
      return [];
    }
  }

  Future<List<Komentar>> getCommentsData(String docId) async {
    try {
      QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
          .collection('laporan')
          .doc(docId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      List<Komentar> comments = commentSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Komentar(
          nama: data['nama'] ?? '',
          isi: data['comment'] ?? '',
          waktu: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();

      return comments;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting comments data: $e');
      }
      return [];
    }
  }
}
