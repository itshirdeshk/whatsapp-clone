import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/call/screens/call_screen.dart';
import 'package:whatsapp_ui/models/call.dart';

import '../../../models/group.dart';

final callRepositoryProvider = Provider((ref) => CallRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class CallRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  CallRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.callId)
          .set(receiverCallData.toMap());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderCallData.callId,
                  call: senderCallData,
                  isGroupChat: false)));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();

      Group group = Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersIUid) {
        await firestore
            .collection('call')
            .doc(id)
            .set(receiverCallData.toMap());
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderCallData.callId,
                  call: senderCallData,
                  isGroupChat: true)));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(receiverId).get();

      Group group = Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersIUid) {
        await firestore.collection('call').doc(id).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
