import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/group/controller/group_controller.dart';
import 'package:whatsapp_ui/features/group/widgets/select_contacts_group.dart';
import 'package:whatsapp_ui/features/select_contacts/screens/select_contacts_screen.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = 'create-group';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
          context,
          groupNameController.text.trim(),
          image!,
          ref.read(selectedGroupContacts));
      ref.read(selectedGroupContacts.notifier).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            children: [
              image == null
                  ? const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(image!),
                    ),
              Positioned(
                  bottom: -10,
                  right: 0,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: groupNameController,
              decoration: const InputDecoration(hintText: "Enter Group Name"),
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Select Contacts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
          const SelectContactScreen()
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
