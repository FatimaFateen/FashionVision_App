import 'package:flutter/material.dart';

class SaveOrChatDialog extends StatelessWidget {
  const SaveOrChatDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: const Center(
        child: Text(
          "Almost there!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Chat with Tailors to get afforable deals, or save for later use"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (index) {
                return TextButton(
                  onPressed: () {
                    if (index == 0) {
                      Navigator.pop(context, "Save");
                    } else {
                      Navigator.pop(context, "Chat");
                    }
                  },
                  style: const ButtonStyle().copyWith(
                    backgroundColor: WidgetStatePropertyAll(index == 0
                        ? Colors.black.withOpacity(.7)
                        : Colors.pinkAccent),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    minimumSize: const WidgetStatePropertyAll(Size(120, 45)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  child: Text(index == 0 ? "Save" : "Chat now"),
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
