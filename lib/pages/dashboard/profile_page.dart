import 'package:bk_lapor_book/components/error_widget.dart';
import 'package:bk_lapor_book/components/loading_widget.dart';
import 'package:bk_lapor_book/components/styles.dart';
import 'package:bk_lapor_book/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  void logOut(BuildContext context, WidgetRef ref) {
    ref.read(controllerProvider.notifier).logout();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final akunData = ref.watch(getAkunProvider);
    return akunData.when(
      data: (data) => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Text(
              data.nama,
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            Text(
              data.role,
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: primaryColor)),
              ),
              child: Text(
                data.noHP,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: primaryColor)),
              ),
              child: Text(
                data.email,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: buttonStyle,
                onPressed: () => logOut(context, ref),
                child: const Text('Logout',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
      error: (error, stackTrace) => const CustomErrorWidget(),
      loading: () => const CustomLoadingWidget(),
    );
  }
}
