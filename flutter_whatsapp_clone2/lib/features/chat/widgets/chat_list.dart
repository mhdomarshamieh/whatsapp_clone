import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/common/enums/message_enum.dart';
import 'package:flutter_whatsapp_clone2/common/providers/message_reply_provider.dart';
import 'package:flutter_whatsapp_clone2/common/widgets/loader.dart';
import 'package:flutter_whatsapp_clone2/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone2/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsapp_clone2/models/message.dart';
import 'package:flutter_whatsapp_clone2/features/chat/widgets/my_message_card.dart';
import 'package:flutter_whatsapp_clone2/features/chat/widgets/sender_message_card.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum type) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            type,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.watch(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(
              messageController.position.maxScrollExtent,
            );
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final message = snapshot.data![index];
              final timeSent = DateFormat.Hm().format(message.timeSent);

              if (!message.isSeen &&
                  message.receiverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context: context,
                      receiverUserId: message.receiverId,
                      messageId: message.messageId,
                    );
              }
              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text,
                  date: timeSent,
                  type: message.type,
                  repliedText: message.repliedMessage,
                  userName: message.repliedTo,
                  repliedMessageType: message.repliedMessageType,
                  onLeftSwipe: () => onMessageSwipe(
                    message.text,
                    true,
                    message.type,
                  ),
                  isSeen: message.isSeen,
                );
              }
              return SenderMessageCard(
                message: message.text,
                date: timeSent,
                type: message.type,
                repliedMessageType: message.repliedMessageType,
                repliedText: message.repliedMessage,
                userName: message.repliedTo,
                onRightSwipe: () => onMessageSwipe(
                  message.text,
                  false,
                  message.type,
                ),
              );
            },
          );
        });
  }
}
