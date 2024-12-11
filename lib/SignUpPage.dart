import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Upload_image.dart';
import 'package:fyp/dialogs/auth_dialog.dart';
import 'package:fyp/extensions/validators.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/auth_services.dart';
import 'package:fyp/tailor_dashboard/dashboard.dart';
import 'package:fyp/widgets/back_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final userName = TextEditingController();
  final tailorPrice = TextEditingController();

  bool isLoading = false;
  String userRole = "";

  Future<void> signup() async {
    if (userRole.isEmpty) {
      bool? loginAs = await showDialog(
          context: context, builder: (context) => const AuthDialog());
      if (loginAs != null) {
        final String role = loginAs ? "Tailor" : "User";
        if (role == "Tailor") {
          setState(() {
            userRole = "Tailor";
          });
        } else {
          setState(() {
            userRole = "User";
          });
        }
      }
    }

    if (emailController.value.text.isEmpty) {
      AppToasts.instance.simple(title: "Please enter your email.");
      return;
    }
    final emailMessage = emailController.text.isValidEmail();
    if (emailMessage != null) {
      AppToasts.instance.simple(title: emailMessage);
      return;
    }
    if (passwordController.value.text.trim().isEmpty) {
      AppToasts.instance.simple(title: "Please enter your password.");
      return;
    }
    if (passwordController.text.trim().length < 6) {
      AppToasts.instance
          .simple(title: "Password must be at least 6 characters long.");
      return;
    }
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      AppToasts.instance.simple(title: "Passwords do not match.");
      return;
    }
    if (userName.text.trim().isEmpty) {
      AppToasts.instance.simple(title: "Please enter your name.");
      return;
    }
    if (userRole == "Tailor" && tailorPrice.text.trim().isEmpty) {
      AppToasts.instance.simple(title: "Please enter your tailoring price.");
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      await AuthServices.instance.createUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: userName.text.trim(),
        role: userRole,
        tailorPrice:
            userRole == "Tailor" ? int.parse(tailorPrice.text.trim()) : null,
      );
      setState(() {
        isLoading = false;
      });
      AppToasts.instance.simple(title: "Account created successfully.");
      if (userRole == "Tailor") {
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
    } catch (e) {
      passwordController.clear();
      confirmPasswordController.clear();
      AppToasts.instance.filled(
          title: "Oh no",
          description:
              e is FirebaseAuthException ? (e).message : "An error occurred");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        leading: const KBackButton(),
        leadingWidth: 90,
      ),
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
            enabled: isLoading, child: initialState(screenSize, context)),
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
                              builder: (context) => const LoginPage()));
                    },
                  text: index == 0 ? "Already have an account?" : " Login",
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

  Column initialState(Size screenSize, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.9,
              maxHeight: screenSize.height * 0.8,
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
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.pinkAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.pinkAccent),
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: userName,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.pinkAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.pinkAccent),
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
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.pinkAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.pinkAccent),
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
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.pinkAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.pinkAccent),
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
                  const SizedBox(height: 10.0),
                  userRole == "Tailor"
                      ? TextField(
                          controller: tailorPrice,
                          decoration: InputDecoration(
                            labelText: 'Enter your price',
                            labelStyle:
                                const TextStyle(color: Colors.pinkAccent),
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
                          obscureText: false,
                          keyboardType: TextInputType.number,
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await signup();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
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
      ],
    );
  }
}
