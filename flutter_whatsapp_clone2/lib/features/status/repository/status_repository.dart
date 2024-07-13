import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutter_whatsapp_clone2/common/utils/utils.dart';
import 'package:flutter_whatsapp_clone2/models/status_model.dart';
import 'package:flutter_whatsapp_clone2/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) {
    return StatusRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      ref: ref,
    );
  },
);

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  const StatusRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  void uploadStatus({
    required String userName,
    required String phoneNumber,
    required String profilePic,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl =
          await ref.read(commonStorageRepositoryProvider).storeFileToFirebase(
                '/status/$statusId$uid',
                statusImage,
              );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
      }
      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(
            userDataFirebase.docs[0].data(),
          );
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrl = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(
          statusesSnapshot.docs[0].data(),
        );
        statusImageUrl = status.photoUrl;
        statusImageUrl.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrl,
        });
        return;
      } else {
        statusImageUrl = [imageUrl];
      }

      Status status = Status(
        uid: uid,
        userName: userName,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrl,
        createAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(status.uid).set(
            status.toMap(),
          );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
