import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/pages/dashboard/all_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/my_laporan_page.dart';
import 'package:bk_lapor_book/pages/dashboard/profile_page.dart';
import 'package:flutter/material.dart';

List<String> dataStatus = ['Posted', 'Proses', 'Selesai'];
List<Color> warnaStatus = [warningColor, dangerColor, successColor];
List<String> dataInstansi = ['Pembangunan', 'Jalanan', 'Pendidikan'];
List<Widget> pages = const <Widget>[
  AllLaporan(),
  MyLaporan(),
  Profile(),
];
