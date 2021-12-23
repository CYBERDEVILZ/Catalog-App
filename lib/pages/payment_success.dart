import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delay();
  }

  void delay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      "assets/lottie/done.json",
      height: 300,
      repeat: false,
    ));
  }
}
