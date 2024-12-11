import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp/SignUpPage.dart';
import 'package:fyp/extensions/validators.dart';
import 'package:fyp/models/app_user.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/firestore_services.dart';
import 'package:fyp/tailor_dashboard/dashboard.dart';
import 'package:fyp/widgets/back_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'upload_image.dart'; // Ensure this is the correct import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  Future<void> loginUser() async {
    final hasError = emailController.value.text.trim().isValidEmail();
    bool passwordIsCorrect = passwordController.value.text.trim().length > 6;
    if (hasError != null) {
      AppToasts.instance.filled(title: hasError);
      return;
    }
    if (!passwordIsCorrect) {
      AppToasts.instance
          .filled(title: 'Password should be at least 7 characters long');
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.value.text.trim(),
              password: passwordController.value.text.trim());
      final User? user = cred.user;
      if (user != null) {
        AppUser? appUser =
            await FirestoreServices.instance.getAppUserFromFirestore();
        if (appUser != null) {
          AppToasts.instance.simple(title: "Logged in successfully");
          setState(() {
            isLoading = true;
          });
          final role = appUser.role;
          if (role == "Tailor") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const TailorDashboard(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const UploadImagePage(),
              ),
            );
          }
        } else {
          AppToasts.instance
              .filled(title: 'User not found or password is incorrect');
          setState(() {
            isLoading = true;
          });
        }
      } else {
        setState(() {
          isLoading = true;
        });
        AppToasts.instance.filled(title: 'User not found');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      AppToasts.instance.filled(
          title: "Oh no!",
          description: e is FirebaseAuthException
              ? e.message
              : "An invalid error occurred.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const KBackButton(),
        leadingWidth: 80,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/ethnic-signupmodel.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Skeletonizer(
          enabled: isLoading,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.9,
                maxHeight: screenSize.height * 0.6,
              ),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    // Email field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.pinkAccent),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.pinkAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.pink[50],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    // Password field
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.pinkAccent),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.pinkAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.pink[50],
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20.0),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Text.rich(
          TextSpan(
            children: List.generate(2, (index) {
              return TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      while (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                  text: index == 0 ? "Don't have an account?" : " Signup",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: index == 0 ? null : FontWeight.bold,
                    color: index == 0 ? null : Colors.pinkAccent,
                  ));
            }),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//! TODO - Firebase auth, Dashboard, Integration(Model), User & Tailor , Tailor Price, 