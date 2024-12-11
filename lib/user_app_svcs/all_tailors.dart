import 'package:flutter/material.dart';
import 'package:fyp/models/app_user.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/firestore_services.dart';
import 'package:fyp/user_app_svcs/chat_user.dart';
import 'package:gap/gap.dart';

class AllTailorsView extends StatefulWidget {
  final String image;
  const AllTailorsView({super.key, required this.image});

  @override
  State<AllTailorsView> createState() => _AllTailorsViewState();
}

class _AllTailorsViewState extends State<AllTailorsView> {
  bool isLoading = false;
  List<AppUser> tailors = [];

  void getAllTailors() async {
    try {
      setState(() {
        isLoading = true;
      });
      final users = await FirestoreServices.instance.getAllTailors();
      tailors = users;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      AppToasts.instance.simple(title: "An error occured");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getAllTailors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Tailors"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              itemCount: tailors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatUser(
                          appUser: tailors[index],
                          image: widget.image,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
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
                            tailors[index].username[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tailors[index].username,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                "Starting from ${tailors[index].tailorPrice} PKR"),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
