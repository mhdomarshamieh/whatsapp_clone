import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/common/enums/message_enum.dart';
import 'package:flutter_whatsapp_clone2/common/providers/message_reply_provider.dart';
import 'package:flutter_whatsapp_clone2/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutter_whatsapp_clone2/common/utils/utils.dart';
import 'package:flutter_whatsapp_clone2/models/chat_contact.dart';
import 'package:flutter_whatsapp_clone2/models/message.dart';
import 'package:flutter_whatsapp_clone2/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    DateTime timeSent,
    String text,
    String receiverUserId,
  ) async {
    ChatContact receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilPic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );

    ChatContact senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilPic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required MessageEnum repliedMessageType,
  }) async {
    Message message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : receiverUserName,
      repliedMessageType: repliedMessageType,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    // users -> sender id -> receiver id -> messages -> message id
    try {
      var timeSent = DateTime.now();

      UserModel receiverUserData;

      var receiverUserDataAsMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(receiverUserDataAsMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        timeSent,
        text,
        receiverUserId,
        //deneme
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        receiverUserName: receiverUserData.name,
        userName: senderUser.name,
        messageReply: messageReply,
        senderUserName: senderUser.name,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.type,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> contacts = [];
        for (var document in event.docs) {
          ChatContact chatContact = ChatContact.fromMap(document.data());
          var userData = await firestore
              .collection('users')
              .doc(chatContact.contactId)
              .get();
          var user = UserModel.fromMap(userData.data()!);
          contacts.add(
            ChatContact(
              name: user.name,
              profilePic: user.profilPic,
              contactId: chatContact.contactId,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage,
            ),
          );
        }
        return contacts;
      },
    );
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap(
      (event) {
        List<Message> messages = [];
        for (var document in event.docs) {
          messages.add(
            Message.fromMap(
              document.data(),
            ),
          );
        }
        return messages;
      },
    );
  }

  void sendFileMessage({
    required BuildContext context,
    required String receiverUserId,
    required File file,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum type,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      final String imageUrl =
          await ref.read(commonStorageRepositoryProvider).storeFileToFirebase(
                'chat/${type.type}/${senderUserData.uid}/$receiverUserId/$messageId',
                file,
              );
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      String contactMsg = '';
      switch (type) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;

        case MessageEnum.audio:
          contactMsg = '🎼 Audio';
          break;

        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;

        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        case MessageEnum.text:
          break;
        default:
          contactMsg = 'Text';
      }
      _saveDataToContactsSubCollection(
        senderUserData,
        receiverUserData,
        timeSent,
        contactMsg,
        receiverUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        messageType: type,
        messageReply: messageReply,
        senderUserName: senderUserData.name,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.type,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update(
        {
          'isSeen': true,
        },
      );
      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update(
        {
          'isSeen': true,
        },
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
