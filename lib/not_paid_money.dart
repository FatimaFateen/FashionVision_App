import 'package:flutter/material.dart';

class NotPaidMoney extends StatelessWidget {
  const NotPaidMoney({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Pay money first"),
      ),
    );
  }
}
