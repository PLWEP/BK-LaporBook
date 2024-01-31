class Akun {
  final String uid;
  final String docId;
  final String nama;
  final String noHP;
  final String email;
  final String role;

  Akun({
    required this.uid,
    required this.docId,
    required this.nama,
    required this.noHP,
    required this.email,
    required this.role,
  });

  Akun copyWith({
    String? uid,
    String? docId,
    String? nama,
    String? noHP,
    String? email,
    String? role,
  }) {
    return Akun(
      uid: uid ?? this.uid,
      docId: docId ?? this.docId,
      nama: nama ?? this.nama,
      noHP: noHP ?? this.noHP,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'docId': docId,
      'nama': nama,
      'noHP': noHP,
      'email': email,
      'role': role,
    };
  }

  factory Akun.fromMap(Map<String, dynamic> map) {
    return Akun(
      uid: map['uid'] as String,
      docId: map['docId'] as String,
      nama: map['nama'] as String,
      noHP: map['noHP'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
    );
  }
}
