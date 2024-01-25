import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/models/laporan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;

  final bool isLaporanku;
  const ListItem({
    super.key,
    required this.laporan,
    required this.isLaporanku,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  void deleteLaporan(context) async {
    try {
      await _firestore.collection('laporan').doc(widget.laporan.docId).delete();

      if (widget.laporan.gambar != '') {
        await _storage.refFromURL(widget.laporan.gambar!).delete();
      }
      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

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
            'laporan': widget.laporan,
          });
        },
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: widget.laporan.gambar != ''
                  ? Image.network(
                      widget.laporan.gambar!,
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
                widget.laporan.judul,
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
                      widget.laporan.status,
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
                      DateFormat.yM().format(widget.laporan.tanggal),
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
