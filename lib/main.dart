import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:fyp/Upload_image.dart';
import 'package:fyp/firebase_options.dart';
import 'package:fyp/login_page.dart';
import 'package:fyp/models/app_user.dart';
import 'package:fyp/services/firestore_services.dart';
import 'package:fyp/services/supabase.dart';
import 'package:fyp/tailor_dashboard/dashboard.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SupabaseServices.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Fashion Vision',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: Colors.transparent,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  AppUser? appUser;
  bool isLoading = false;

  void getAppUser() async {
    setState(() {
      isLoading = true;
    });
    AppUser? user = await FirestoreServices.instance.getAppUserFromFirestore();
    if (user != null) {
      appUser = user;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAppUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final double titleFontSize = screenWidth * 0.08;
    final double subtitleFontSize = screenWidth * 0.04;
    final double imageHeight = screenHeight * 0.25;

    return Scaffold(
      backgroundColor: const Color(0xFFE6D0BC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Text(
                  'FashionVision',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Text(
                  'Imagination meets designs',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Image.asset('assets/wel3-removebg-preview.png',
                      height: imageHeight),
                  Image.asset('assets/wel4-removebg-preview.png',
                      height: imageHeight),
                  Image.asset('assets/wel5-removebg-preview.png',
                      height: imageHeight),
                  Image.asset('assets/wel6-removebg-preview.png',
                      height: imageHeight),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              Skeletonizer(
                enabled: isLoading,
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: ElevatedButton(
                    onPressed: () {
                      if (appUser != null) {
                        if (appUser!.role == "Tailor") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TailorDashboard(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UploadImagePage(),
                            ),
                          );
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
