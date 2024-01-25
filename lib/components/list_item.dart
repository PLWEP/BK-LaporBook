import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/models/laporan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final Laporan laporan;

  final bool isLaporanku;
  const ListItem({
    super.key,
    required this.laporan,
    required this.isLaporanku,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: {
            'laporan': laporan,
          });
        },
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: laporan.gambar != ''
                  ? Image.network(
                      laporan.gambar!,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/istock-default.jpg',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(width: 2),
                ),
              ),
              child: Text(
                laporan.judul,
                style: headerStyle(level: 4),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                      color: warningColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border.symmetric(
                        vertical: BorderSide(width: 1),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      laporan.status,
                      style: headerStyle(level: 5, dark: false),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                      color: warningColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border.symmetric(
                        vertical: BorderSide(width: 1),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat.yM().format(laporan.tanggal),
                      style: headerStyle(level: 5, dark: false),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
