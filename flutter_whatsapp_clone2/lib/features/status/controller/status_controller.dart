import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone2/features/status/repository/status_repository.dart';
import 'package:flutter_whatsapp_clone2/models/status_model.dart';

final statusControllerProvider = Provider(
  (ref) {
    final statusRepository = ref.read(statusRepositoryProvider);
    return StatusController(
      ref: ref,
      statusRepository: statusRepository,
    );
  },
);

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.ref,
    required this.statusRepository,
  });

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData(
      (data) {
        statusRepository.uploadStatus(
          userName: data!.name,
          phoneNumber: data.phoneNumber,
          profilePic: data.profilPic,
          statusImage: file,
          context: context,
        );
      },
    );
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
