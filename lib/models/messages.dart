import 'package:whatsapp_ui/common/enums/message_enums.dart';

class Messages {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMesage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Messages({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMesage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMesage': repliedMesage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      repliedMesage: map['repliedMesage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }
}
