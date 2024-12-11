import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KBackButton extends StatelessWidget {
  const KBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return canPop
        ? Center(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.chevron_back),
              style: const ButtonStyle().copyWith(
                backgroundColor:
                    WidgetStatePropertyAll(Colors.black.withOpacity(.2)),
                minimumSize: const WidgetStatePropertyAll(Size(45, 45)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
