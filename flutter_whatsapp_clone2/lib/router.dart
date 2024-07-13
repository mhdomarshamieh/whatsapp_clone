import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone2/common/widgets/error.dart';
import 'package:flutter_whatsapp_clone2/features/auth/screens/login_screen.dart';
import 'package:flutter_whatsapp_clone2/features/auth/screens/otp_screen.dart';
import 'package:flutter_whatsapp_clone2/features/auth/screens/user_information_screen.dart';
import 'package:flutter_whatsapp_clone2/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_whatsapp_clone2/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:flutter_whatsapp_clone2/features/status/screens/confirm_status_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OtpScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final String name = arguments['name'];
      final String uid = arguments['uid'];

      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
