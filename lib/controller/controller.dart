import 'package:bk_lapor_book/models/laporan.dart';
import 'package:bk_lapor_book/repository/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Controller extends StateNotifier<bool> {
  final Repository _repository;

  Controller({
    required Repository repository,
  })  : _repository = repository,
        super(false);

  Stream<List<Laporan>> getAllLaporan() => _repository.getAllLaporan();
}
