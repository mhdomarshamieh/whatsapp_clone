import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

//<editor-fold desc="Data Methods">
  const ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatContact &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          profilePic == other.profilePic &&
          contactId == other.contactId &&
          timeSent == other.timeSent &&
          lastMessage == other.lastMessage);

  @override
  int get hashCode =>
      name.hashCode ^
      profilePic.hashCode ^
      contactId.hashCode ^
      timeSent.hashCode ^
      lastMessage.hashCode;

  @override
  String toString() {
    return 'ChatContact{' +
        ' name: $name,' +
        ' profilePic: $profilePic,' +
        ' contactId: $contactId,' +
        ' timeSent: $timeSent,' +
        ' lastMessage: $lastMessage,' +
        '}';
  }

  ChatContact copyWith({
    String? name,
    String? profilePic,
    String? contactId,
    DateTime? timeSent,
    String? lastMessage,
  }) {
    return ChatContact(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      contactId: contactId ?? this.contactId,
      timeSent: timeSent ?? this.timeSent,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'profilePic': this.profilePic,
      'contactId': this.contactId,
      'timeSent': this.timeSent,
      'lastMessage': this.lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      timeSent: (map['timeSent'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] as String,
    );
  }

//</editor-fold>
}
