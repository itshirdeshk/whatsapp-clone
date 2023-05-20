class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> whoCanSee;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> photoUrl;

  
  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.profilePic,
    required this.statusId,
    required this.photoUrl,
    required this.whoCanSee,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'statusId': statusId,
      'photoUrl': photoUrl,
      'whoCanSee': whoCanSee,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      profilePic: map['profilePic'] as String,
      statusId: map['statusId'] as String,
      photoUrl: List<String>.from((map['photoUrl'] as List<String>)),
      whoCanSee: List<String>.from((map['whoCanSee'] as List<String>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}
