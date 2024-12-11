import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/models/chat.dart';
import 'package:fyp/services/firestore_services.dart';

class TailorChat extends StatefulWidget {
  final Chat appUser;
  const TailorChat({super.key, required this.appUser});

  @override
  State<TailorChat> createState() => _ChatUserState();
}

class _ChatUserState extends State<TailorChat> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appUser.senderName),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirestoreServices.instance
            .singleUserChatStreamForTailor(widget.appUser.sender),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final hasError = snapshot.hasError;
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
