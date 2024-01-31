class Komentar {
  final String nama;
  final String isi;
  final DateTime waktu;

  Komentar({
    required this.nama,
    required this.isi,
    required this.waktu,
  });

  Komentar copyWith({
    String? nama,
    String? isi,
    DateTime? waktu,
  }) {
    return Komentar(
      nama: nama ?? this.nama,
      isi: isi ?? this.isi,
      waktu: waktu ?? this.waktu,
    );
  }

  factory Komentar.fromMap(Map<String, dynamic> map) {
    return Komentar(
      nama: map['nama'] as String,
      isi: map['isi'] as String,
      waktu: map['waktu'].toDate() as DateTime,
    );
  }
}
