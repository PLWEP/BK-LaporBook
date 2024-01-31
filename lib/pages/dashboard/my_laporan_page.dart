import 'package:bk_lapor_book/components/error_widget.dart';
import 'package:bk_lapor_book/components/list_item.dart';
import 'package:bk_lapor_book/components/loading_widget.dart';
import 'package:bk_lapor_book/provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyLaporan extends ConsumerWidget {
  const MyLaporan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listLaporan = ref.watch(getMyLaporanProvider);

    return listLaporan.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.air, size: 50),
                Text('Mohon maaf data tidak tersedia'),
              ],
            ),
          );
        }
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1 / 1.234,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListItem(
                laporan: data[index],
                isLaporanku: false,
              );
            },
          ),
        );
      },
      error: (error, stackTrace) => const CustomErrorWidget(),
      loading: () => const CustomLoadingWidget(),
    );
  }
}
