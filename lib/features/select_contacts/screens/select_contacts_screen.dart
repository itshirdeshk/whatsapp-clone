import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contacts_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = 'select-contacts';
  const SelectContactScreen({super.key});

  void selectContacts(
      WidgetRef ref, BuildContext context, Contact selectedContact) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactsList) {
            return ListView.builder(
                itemCount: contactsList.length,
                itemBuilder: (context, index) {
                  final contact = contactsList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      onTap: () => selectContacts(ref, context, contact),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: MemoryImage(contact.photo!),
                            ),
                    ),
                  );
                });
          },
          error: (error, stackTrace) => ErrorScreen(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
