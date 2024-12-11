import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/main.dart';
import 'package:fyp/models/app_user.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/firestore_services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  AppUser? user;
  bool isLoading = false;

  void getAppUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      AppUser? appUser =
          await FirestoreServices.instance.getAppUserFromFirestore();
      if (appUser != null) {
        user = appUser;
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception("");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error is $e');
      AppToasts.instance.simple(title: "An error occurred.");
    }
  }

  @override
  void initState() {
    getAppUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Skeletonizer(
        enabled: isLoading, child: initialState(width, context, user: user));
  }

  ListView initialState(
    double width,
    BuildContext context, {
    AppUser? user,
  }) {
    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: width,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(user != null ? user.username : "Unknow Tailor"),
        ),
        const Gap(12),
        Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Member since"),
                Text(
                  DateFormat("dd MMM yyyy")
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          user != null ? user.createdAt : 0))
                      .toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )),
        const Gap(12),
        Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Minumum Price"),
                Text(
                  (user != null ? user.tailorPrice : 0).toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )),
        const Gap(60),
        Center(
          child: TextButton(
            style: const ButtonStyle().copyWith(
              minimumSize: const WidgetStatePropertyAll(Size(200, 45)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              backgroundColor: WidgetStatePropertyAll(
                Colors.black.withOpacity(.7),
              ),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ));
            },
            child: const Text("Logout"),
          ),
        ),
      ],
    );
  }
}
