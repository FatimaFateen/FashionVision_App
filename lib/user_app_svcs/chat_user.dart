import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/models/app_user.dart';
import 'package:fyp/models/chat.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/firestore_services.dart';
import 'package:uuid/uuid.dart';

class ChatUser extends StatefulWidget {
  final AppUser appUser;
  final String image;
  const ChatUser({super.key, required this.appUser, required this.image});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  final controller = TextEditingController();

  Future<void> startANewChat({
    required AppUser appUser,
  }) async {
    try {
      Chat chat = Chat(
          receiverName: appUser.username,
          senderName:
              FirebaseAuth.instance.currentUser!.displayName ?? "Unknow user",
          receiver: appUser.uid,
          sender: FirebaseAuth.instance.currentUser!.uid,
          messages: [],
          id: const Uuid().v6());
      await FirestoreServices.instance
          .startANewChat(chat: chat, receiverId: appUser.uid);
    } catch (e) {
      AppToasts.instance.simple(
        title: "Unable to start chat with ${appUser.username}",
      );
    }
  }

  @override
  void initState() {
    startANewChat(appUser: widget.appUser);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appUser.username),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirestoreServices.instance
            .singleUserChatStreamForUser(widget.appUser.uid),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final hasError = snapshot.hasError;
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // ! Look here 👋🏻
          /*
          if you want pehla message just image ka ho, nechay walay if k andar paste this
          (snapshot.data?.messages ?? []).isEmpty
          */
          if ((snapshot.data?.messages ?? [])
                  .any((e) => e.message.trim() == widget.image) ==
              false) {
            FirestoreServices.instance.addMessageToChat(
              snapshot.data!.id,
              message: Messages(
                  message: widget.image,
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  time: DateTime.now().millisecondsSinceEpoch),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: snapshot.data!.messages[index].uid ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: snapshot.data!.messages[index].message
                                .endsWith(".png")
                            ? CachedNetworkImage(
                                imageUrl:
                                    snapshot.data!.messages[index].message,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width * .6,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => SizedBox(
                                    height: 200,
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: const Center(
                                        child: CircularProgressIndicator())),
                                errorWidget: (context, url, error) => SizedBox(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: const Center(child: Icon(Icons.error)),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * .6,
                                  minHeight: 30,
                                  minWidth: 60,
                                ),
                                decoration: BoxDecoration(
                                  color: snapshot.data!.messages[index].uid ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Colors.pinkAccent
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Text(
                                  snapshot.data!.messages[index].message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Enter a message",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (controller.text.trim().isNotEmpty) {
                          await FirestoreServices.instance.addMessageToChat(
                              snapshot.data!.id,
                              message: Messages(
                                  message: controller.text.trim(),
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  time: DateTime.now().millisecondsSinceEpoch));
                          controller.clear();
                        }
                      },
                      icon: const Icon(CupertinoIcons.paperplane_fill),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
