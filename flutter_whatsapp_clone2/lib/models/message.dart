import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_whatsapp_clone2/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

//<editor-fold desc="Data Methods">
  const Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          runtimeType == other.runtimeType &&
          senderId == other.senderId &&
          receiverId == other.receiverId &&
          text == other.text &&
          type == other.type &&
          timeSent == other.timeSent &&
          messageId == other.messageId &&
          isSeen == other.isSeen &&
          repliedMessage == other.repliedMessage &&
          repliedTo == other.repliedTo &&
          repliedMessageType == other.repliedMessageType);

  @override
  int get hashCode =>
      senderId.hashCode ^
      receiverId.hashCode ^
      text.hashCode ^
      type.hashCode ^
      timeSent.hashCode ^
      messageId.hashCode ^
      isSeen.hashCode ^
      repliedMessage.hashCode ^
      repliedTo.hashCode ^
      repliedMessageType.hashCode;

  @override
  String toString() {
    return 'Message{' +
        ' senderId: $senderId,' +
        ' receiverId: $receiverId,' +
        ' text: $text,' +
        ' type: $type,' +
        ' timeSent: $timeSent,' +
        ' messageId: $messageId,' +
        ' isSeen: $isSeen,' +
        ' repliedMessage: $repliedMessage,' +
        ' repliedTo: $repliedTo,' +
        ' repliedMessageType: $repliedMessageType,' +
        '}';
  }

  Message copyWith({
    String? senderId,
    String? receiverId,
    String? text,
    MessageEnum? type,
    DateTime? timeSent,
    String? messageId,
    bool? isSeen,
    String? repliedMessage,
    String? repliedTo,
    MessageEnum? repliedMessageType,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      type: type ?? this.type,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
      repliedMessage: repliedMessage ?? this.repliedMessage,
      repliedTo: repliedTo ?? this.repliedTo,
      repliedMessageType: repliedMessageType ?? this.repliedMessageType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: (map['timeSent'] as Timestamp).toDate(),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }

//</editor-fold>
}
