import 'package:bk_lapor_book/common/constant.dart';
import 'package:bk_lapor_book/models/laporan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  final FirebaseFirestore _firestore;

  Repository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _laporanCollections =>
      _firestore.collection(Constants.laporanCollection);

  Stream<List<Laporan>> getAllLaporan() => _laporanCollections.snapshots().map(
        (event) => event.docs
            .map((event) =>
                Laporan.fromMap(event.data() as Map<String, dynamic>))
            .toList(),
      );
}
