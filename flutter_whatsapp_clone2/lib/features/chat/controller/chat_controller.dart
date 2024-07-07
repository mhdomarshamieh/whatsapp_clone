import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/common/enums/message_enum.dart';
import 'package:flutter_whatsapp_clone2/common/providers/message_reply_provider.dart';
import 'package:flutter_whatsapp_clone2/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone2/features/chat/repository/chat_repository.dart';
import 'package:flutter_whatsapp_clone2/models/chat_contact.dart';
import 'package:flutter_whatsapp_clone2/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
      (value) {
        chatRepository.sendTextMessage(
          context: context,
          text: text,
          receiverUserId: receiverUserId,
          senderUser: value!,
          messageReply: messageReply,
        );
      },
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum type,
  ) {
    final messageReply = ref.watch(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
      (value) {
        chatRepository.sendFileMessage(
          context: context,
          file: file,
          ref: ref,
          receiverUserId: receiverUserId,
          senderUserData: value!,
          type: type,
          messageReply: messageReply,
        );
      },
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) {
    chatRepository.setChatMessageSeen(
      context: context,
      receiverUserId: receiverUserId,
      messageId: messageId,
    );
  }
}
