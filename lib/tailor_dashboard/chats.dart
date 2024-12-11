import 'package:flutter/material.dart';
import 'package:fyp/models/chat.dart';
import 'package:fyp/services/stream_services.dart';
import 'package:fyp/tailor_dashboard/tailor_chat.dart';
import 'package:gap/gap.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: StreamServices.instance.getTailorSteam(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const SizedBox();
        } else if (snapshot.hasData) {
          List<Chat>? chats = snapshot.data;
          if (chats != null && chats.isEmpty) {
            return const Center(
              child: Text("You don't have messages yet!"),
            );
          } else if (chats != null && chats.isNotEmpty) {
            final List<Chat> newList =
                chats.where((e) => e.messages.isNotEmpty).toList();
            return ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              itemCount: newList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TailorChat(appUser: newList[index]);
                    },
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 25,
                          child: Text(
                            newList[index].senderName[0],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newList[index].senderName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(newList[index].messages.last.message),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
