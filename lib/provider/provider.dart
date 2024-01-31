import 'package:bk_lapor_book/controller/controller.dart';
import 'package:bk_lapor_book/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllLaporanProvider = StreamProvider(
  (ref) => ref.watch(controllerProvider.notifier).getAllLaporan(),
);

final controllerProvider = StateNotifierProvider<Controller, bool>(
  (ref) => Controller(repository: ref.watch(repositoryProvider)),
);

final repositoryProvider = Provider(
  (ref) => Repository(firestore: ref.watch(firestoreProvider)),
);

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final currentPageProvider = StateProvider<int>((ref) => 0);
