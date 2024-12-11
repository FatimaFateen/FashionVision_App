import 'package:flutter/material.dart';

class AuthDialog extends StatelessWidget {
  const AuthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: const Center(
        child: Text(
          "Signup as",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("You want to sign up as?"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (index) {
                return TextButton(
                  onPressed: () {
                    if (index == 0) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context, false);
                    }
                  },
                  style: const ButtonStyle().copyWith(
                    backgroundColor: WidgetStatePropertyAll(index == 0
                        ? Colors.black.withOpacity(.7)
                        : Colors.pinkAccent),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    minimumSize: const WidgetStatePropertyAll(Size(90, 45)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  child: Text(index == 0 ? "Tailor" : "User"),
                );
              }),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
