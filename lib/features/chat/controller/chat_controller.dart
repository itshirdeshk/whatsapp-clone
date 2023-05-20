// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_ui/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/messages.dart';

import '../../../models/group.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              recieverUserId: recieverUserId,
              senderUserData: value!,
              messageEnum: messageEnum,
              messageReply: messageReply,
              ref: ref,
              isGroupChat: isGroupChat,
            ));
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Messages>> getChatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Messages>> getGroupChatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendGIFMessage(BuildContext context, String gifUrl,
      String recieverUserId, bool isGroupChat) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendGIF(
        context: context,
        gifUrl: newGifUrl,
        recieverUserId: recieverUserId,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
        senderUser: value!));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context, String recieverUserId, String messageId) {
    chatRepository.setChatMessageSeen(context, recieverUserId, messageId);
  }
}
