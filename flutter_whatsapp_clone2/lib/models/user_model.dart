class UserModel {
  final String name;
  final String uid;
  final String profilPic;
  final bool isOnline;
  final String phoneNumber;
  final List<dynamic> groupsId;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.name,
    required this.uid,
    required this.profilPic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupsId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          uid == other.uid &&
          profilPic == other.profilPic &&
          isOnline == other.isOnline &&
          phoneNumber == other.phoneNumber &&
          groupsId == other.groupsId);

  @override
  int get hashCode =>
      name.hashCode ^
      uid.hashCode ^
      profilPic.hashCode ^
      isOnline.hashCode ^
      phoneNumber.hashCode ^
      groupsId.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' name: $name,' +
        ' uid: $uid,' +
        ' profilPic: $profilPic,' +
        ' isOnline: $isOnline,' +
        ' phoneNumber: $phoneNumber,' +
        ' groupsId: $groupsId,' +
        '}';
  }

  UserModel copyWith({
    String? name,
    String? uid,
    String? profilPic,
    bool? isOnline,
    String? phoneNumber,
    List<dynamic>? groupsId,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilPic: profilPic ?? this.profilPic,
      isOnline: isOnline ?? this.isOnline,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      groupsId: groupsId ?? this.groupsId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilPic': profilPic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupsId': groupsId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilPic: map['profilPic'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      groupsId: map['groupsId'] as List<dynamic>,
    );
  }

//</editor-fold>
}
