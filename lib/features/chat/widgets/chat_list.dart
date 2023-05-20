// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_ui/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/models/messages.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.notifier).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Messages>>(
        stream: widget.isGroupChat ? ref
            .read(chatControllerProvider)
            .getGroupChatStream(widget.recieverUserId) : 
        ref
            .read(chatControllerProvider)
            .getChatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (!messageData.isSeen &&
                  messageData.recieverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                    context, widget.recieverUserId, messageData.messageId);
              }

              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedtext: messageData.repliedMesage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  isSeen: messageData.isSeen,
                  onLeftSwipe: () =>
                      onMessageSwipe(messageData.text, true, messageData.type),
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedtext: messageData.repliedMesage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe: () =>
                    onMessageSwipe(messageData.text, false, messageData.type),
              );
            },
          );
        });
  }
}
