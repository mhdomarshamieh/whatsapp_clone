import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/features/auth/controller/auth_controller.dart';

import '../../../colors.dart';

class OtpScreen extends ConsumerWidget {
  static const routeName = '/otp-screen';
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  void verifyOtp(WidgetRef ref, BuildContext context, String userOtp) {
    ref.read(authControllerProvider).verifyOtp(
          context,
          verificationId,
          userOtp,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('We have sent an SMS with a code'),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: const TextStyle(
                    fontSize: 30,
                  ),
                ),
                onChanged: (val) {
                  if (val.length == 6) {
                    verifyOtp(ref, context, val.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
