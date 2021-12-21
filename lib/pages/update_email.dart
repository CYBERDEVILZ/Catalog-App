import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateEmail extends StatelessWidget {
  UpdateEmail({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  void updateEmail(BuildContext context, String email) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!
          .verifyBeforeUpdateEmail(email)
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  alignment: Alignment.center,
                  height: 30,
                  child: Text("A confirmation email has been sent.",
                      style: TextStyle(color: Theme.of(context).canvasColor)),
                ),
                behavior: SnackBarBehavior.fixed,
                duration: const Duration(seconds: 3),
                backgroundColor: Theme.of(context).cursorColor,
              )))
          .catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text("An error occured.",
                style: TextStyle(color: Theme.of(context).canvasColor)),
          ),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).cursorColor,
        ));
      });
    }
  }

  final emailUpdateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void validation(BuildContext context, email) {
    if (formKey.currentState!.validate()) {
      updateEmail(context, email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Email"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: FittedBox(child: Text("${_auth.currentUser!.email}")),
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).cursorColor),
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailUpdateController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field cannot be empty";
                  } else if (!RegExp(
                          "^[A-Za-z0-9._-]+@[A-Za-z0-9._-]+[.][A-Za-z0-9]")
                      .hasMatch(value)) {
                    return "Invalid email address";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Update Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    validation(context, emailUpdateController.text);
                  },
                  child: Text("Update",
                      style: TextStyle(color: Theme.of(context).cardColor)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cursorColor),
                      minimumSize:
                          MaterialStateProperty.all(const Size(150, 50)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))))
            ],
          ),
        ),
      ),
    );
  }
}
