import 'package:bk_lapor_book/common/constant.dart';
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
}
