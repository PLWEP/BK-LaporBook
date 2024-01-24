class Laporan {
  final String uid;
  final String docId;

  final String judul;
  final String instansi;
  String? deskripsi;
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
    this.deskripsi,
    this.gambar,
    required this.nama,
    required this.status,
    required this.tanggal,
    required this.maps,
    this.komentar,
  });
}

class Komentar {
  final String nama;
  final String isi;
  final DateTime waktu;

  Komentar({required this.nama, required this.isi, required this.waktu});
}

class Like {
  final DateTime waktu;
  final String uid;
  final String likeid;

  Like({
    required this.waktu,
    required this.uid,
    required this.likeid,
  });
}
