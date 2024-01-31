import 'package:bk_lapor_book/models/komentar.dart';

class Laporan {
  final String uid;
  final String docId;

  final String judul;
  final String instansi;
  String deskripsi;
  String? gambar;
  final String nama;
  final String status;
  final DateTime tanggal;
  final String maps;
  List<Komentar>? komentar;

  Laporan({
    required this.uid,
    required this.docId,
    required this.judul,
    required this.instansi,
    required this.deskripsi,
    this.gambar,
    required this.nama,
    required this.status,
    required this.tanggal,
    required this.maps,
    this.komentar,
  });

  Laporan copyWith({
    String? uid,
    String? docId,
    String? judul,
    String? instansi,
    String? deskripsi,
    String? gambar,
    String? nama,
    String? status,
    DateTime? tanggal,
    String? maps,
    List<Komentar>? komentar,
  }) {
    return Laporan(
      uid: uid ?? this.uid,
      docId: docId ?? this.docId,
      judul: judul ?? this.judul,
      instansi: instansi ?? this.instansi,
      deskripsi: deskripsi ?? this.deskripsi,
      gambar: gambar ?? this.gambar,
      nama: nama ?? this.nama,
      status: status ?? this.status,
      tanggal: tanggal ?? this.tanggal,
      maps: maps ?? this.maps,
      komentar: komentar ?? this.komentar,
    );
  }

  factory Laporan.fromMap(Map<String, dynamic> map) {
    return Laporan(
      uid: map['uid'] as String,
      docId: map['docId'] as String,
      judul: map['judul'] as String,
      instansi: map['instansi'] as String,
      deskripsi: map['deskripsi'] as String,
      gambar: map['gambar'] != null ? map['gambar'] as String : null,
      nama: map['nama'] as String,
      status: map['status'] as String,
      tanggal: map['tanggal'].toDate() as DateTime,
      maps: map['maps'] as String,
      komentar: map['komentar'] != null
          ? List<Komentar>.from(
              (map['komentar'] as List<int>).map<Komentar?>(
                (x) => Komentar.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}
