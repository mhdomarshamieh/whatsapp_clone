import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/colors.dart';
import 'package:flutter_whatsapp_clone2/common/widgets/error.dart';
import 'package:flutter_whatsapp_clone2/common/widgets/loader.dart';
import 'package:flutter_whatsapp_clone2/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone2/features/landing/screens/landing_screen.dart';
import 'package:flutter_whatsapp_clone2/firebase_options.dart';
import 'package:flutter_whatsapp_clone2/router.dart';

import 'screens/mobile_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Whatsapp Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
        data: (data) {
          if (data == null) {
            return const LandingScreen();
          }

          return const MobileScreenLayout();
        },
        error: (error, trace) {
          return ErrorScreen(
            error: error.toString(),
          );
        },
        loading: () {
          return const Loader();
        },
      ),
    );
  }
}
