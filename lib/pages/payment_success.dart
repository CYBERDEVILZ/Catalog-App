import 'package:flutter/material.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedContainer(
      duration: const Duration(seconds: 2),
      child: const Icon(
        Icons.ac_unit,
        size: 100,
      ),
    ));
  }
}
