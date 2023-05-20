class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersIUid;
  final DateTime timeSent;

  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersIUid,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersIUid': membersIUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      groupPic: map['groupPic'] as String,
      membersIUid: List<String>.from((map['membersIUid'] as List<String>)),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}
