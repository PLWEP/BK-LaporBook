import 'package:bk_lapor_book/common/constant.dart';
import 'package:bk_lapor_book/models/akun.dart';
import 'package:bk_lapor_book/models/laporan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Repository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  CollectionReference get _laporanCollections =>
      _firestore.collection(Constants.laporanCollection);

  CollectionReference get _akunCollections =>
      _firestore.collection(Constants.akunCollection);

  Stream<List<Laporan>> getAllLaporan() => _laporanCollections.snapshots().map(
        (event) => event.docs
            .map((event) =>
                Laporan.fromMap(event.data() as Map<String, dynamic>))
            .toList(),
      );

  Stream<List<Laporan>> getMyLaporan() => _laporanCollections
      .where('uid', isEqualTo: _auth.currentUser!.uid)
      .snapshots()
      .map(
        (event) => event.docs
            .map((event) =>
                Laporan.fromMap(event.data() as Map<String, dynamic>))
            .toList(),
      );

  Stream<Akun> getAkunData() => _akunCollections
      .where('uid', isEqualTo: _auth.currentUser!.uid)
      .snapshots()
      .map(
        (event) => event.docs
            .map((event) => Akun.fromMap(event.data() as Map<String, dynamic>))
            .first,
      );

  void logOut() async => await _auth.signOut();
}
