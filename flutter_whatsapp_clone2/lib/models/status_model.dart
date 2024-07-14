import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String uid;
  final String userName;
  final String phoneNumber;
  final List<dynamic> photoUrl;
  final DateTime createAt;
  final String profilePic;
  final String statusId;
  final List<dynamic> whoCanSee;

//<editor-fold desc="Data Methods">
  const Status({
    required this.uid,
    required this.userName,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Status &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          userName == other.userName &&
          phoneNumber == other.phoneNumber &&
          photoUrl == other.photoUrl &&
          createAt == other.createAt &&
          profilePic == other.profilePic &&
          statusId == other.statusId &&
          whoCanSee == other.whoCanSee);

  @override
  int get hashCode =>
      uid.hashCode ^
      userName.hashCode ^
      phoneNumber.hashCode ^
      photoUrl.hashCode ^
      createAt.hashCode ^
      profilePic.hashCode ^
      statusId.hashCode ^
      whoCanSee.hashCode;

  @override
  String toString() {
    return 'Status{' +
        ' uid: $uid,' +
        ' userName: $userName,' +
        ' phoneNumber: $phoneNumber,' +
        ' photoUrl: $photoUrl,' +
        ' createAt: $createAt,' +
        ' profilePic: $profilePic,' +
        ' statusId: $statusId,' +
        ' whoCanSee: $whoCanSee,' +
        '}';
  }

  Status copyWith({
    String? uid,
    String? userName,
    String? phoneNumber,
    List<dynamic>? photoUrl,
    DateTime? createAt,
    String? profilePic,
    String? statusId,
    List<dynamic>? whoCanSee,
  }) {
    return Status(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createAt: createAt ?? this.createAt,
      profilePic: profilePic ?? this.profilePic,
      statusId: statusId ?? this.statusId,
      whoCanSee: whoCanSee ?? this.whoCanSee,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'phoneNumber': this.phoneNumber,
      'photoUrl': this.photoUrl,
      'createAt': this.createAt,
      'profilePic': this.profilePic,
      'statusId': this.statusId,
      'whoCanSee': this.whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: map['photoUrl'] as List<dynamic>,
      createAt: (map['createAt'] as Timestamp).toDate(),
      profilePic: map['profilePic'] as String,
      statusId: map['statusId'] as String,
      whoCanSee: map['whoCanSee'] as List<dynamic>,
    );
  }

//</editor-fold>
}
