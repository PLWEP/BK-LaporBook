import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/pages/dashboard/all_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/my_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/profile_page.dart';
import 'package:flutter/material.dart';

class Constants {
  static const laporanCollection = 'laporan';
  static const akunCollection = 'akun';

  static const List<String> dataStatus = ['Posted', 'Proses', 'Done'];
  static const List<Color> warnaStatus = [
    warningColor,
    dangerColor,
    successColor
  ];
  static const List<String> dataInstansi = [
    'Pembangunan',
    'Jalanan',
    'Pendidikan',
    'Fasilitas Umum',
    'Fasilitas Sosial',
  ];
  static const List<Widget> pages = [
    AllLaporan(),
    MyLaporan(),
    Profile(),
  ];
}
