import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/colors.dart';
import 'package:flutter_whatsapp_clone2/common/widgets/loader.dart';
import 'package:flutter_whatsapp_clone2/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsapp_clone2/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_whatsapp_clone2/models/chat_contact.dart';
import 'package:intl/intl.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                ChatContact contact = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          MobileChatScreen.routeName,
                          arguments: {
                            'name': contact.name,
                            'uid': contact.contactId,
                          },
                        );
                      },
                      child: ListTile(
                        title: Text(
                          contact.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            contact.lastMessage,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            contact.profilePic,
                          ),
                          radius: 30,
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(contact.timeSent),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: dividerColor,
                      indent: 85,
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
