import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/colors.dart';
import 'package:flutter_whatsapp_clone2/common/widgets/loader.dart';
import 'package:flutter_whatsapp_clone2/features/status/controller/status_controller.dart';
import 'package:flutter_whatsapp_clone2/features/status/screens/status_screen.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      StatusScreen.routeName,
                      arguments: statusData,
                    );
                  },
                  child: ListTile(
                    title: Text(
                      statusData.userName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        statusData.profilePic,
                      ),
                      radius: 30,
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
      },
    );
  }
}
