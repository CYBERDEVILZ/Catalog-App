import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  final mailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void validation(String text, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .sendPasswordResetEmail(email: text)
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                      "A confirmation email has been sent to your email address if it exists.",
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                      )),
                ),
                behavior: SnackBarBehavior.fixed,
                duration: const Duration(seconds: 3),
                backgroundColor: Theme.of(context).cursorColor,
              )))
          .catchError(
              (onError) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                          "A confirmation email has been sent to your email address if it exists.",
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                          )),
                    ),
                    behavior: SnackBarBehavior.fixed,
                    duration: const Duration(seconds: 3),
                    backgroundColor: Theme.of(context).cursorColor,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mailField = TextFormField(
      decoration: const InputDecoration(
          labelText: "E-mail",
          prefixIcon: Icon(Icons.mail),
          border: OutlineInputBorder()),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) {
          return "E-mail cannot be empty";
        } else if (!RegExp(
          "^[A-Za-z0-9._-]+@[A-Za-z0-9._-]+[.][A-Za-z0-9]",
        ).hasMatch(value)) {
          return "Invalid E-mail address";
        } else {
          return null;
        }
      },
      controller: mailController,
    );

    final submitButton = ElevatedButton(
        onPressed: () {
          validation(mailController.text, context);
        },
        child: Text("Submit",
            style: TextStyle(color: Theme.of(context).cardColor)),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).cursorColor),
            minimumSize: MaterialStateProperty.all(const Size(150, 50)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))));

    return Scaffold(
        appBar: AppBar(title: const Text("Reset Password")),
        body: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mailField,
                    const SizedBox(height: 20),
                    submitButton
                  ],
                ),
              ),
            )));
  }
}
