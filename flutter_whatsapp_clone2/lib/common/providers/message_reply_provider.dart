import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum type;

  MessageReply(this.message, this.isMe, this.type);
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
