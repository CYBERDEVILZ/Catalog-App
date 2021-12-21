import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _auth = FirebaseAuth.instance;

  bool isDone = true;
  @override
  Widget build(BuildContext context) {
    var formkey = GlobalKey<FormState>();

    //textEditingControllers
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController mailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    //username field
    final usernameField = TextFormField(
      decoration: const InputDecoration(
          labelText: "Username", icon: Icon(Icons.account_circle)),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Username cannot be empty";
        } else {
          return null;
        }
      },
      controller: usernameController,
    );

    //email field
    final mailField = TextFormField(
      decoration:
          const InputDecoration(labelText: "E-mail", icon: Icon(Icons.mail)),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
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

    //password field
    final passwordField = TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
        icon: Icon(Icons.vpn_key),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password cannot be empty";
        } else if (value.length < 6) {
          return "Password must have atleast 6 characters";
        } else {
          return null;
        }
      },
      obscureText: true,
      controller: passwordController,
    );

    //confirmpassword field
    final confirmPasswordField = TextFormField(
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        icon: Icon(Icons.vpn_key),
      ),
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password cannot be empty";
        } else if (value.length < 6) {
          return "Password must have atleast 6 characters";
        } else if (passwordController.value !=
            confirmPasswordController.value) {
          return "Passwords don't match";
        }
      },
      obscureText: true,
      controller: confirmPasswordController,
    );

    // send data to Firestore
    Future<void> sendDetailsToFirestore(username, mail) async {
      User? user = _auth.currentUser;
      var uid = user!.uid;

      Map<String, dynamic> data = {
        "username": username,
        "email": mail,
        "imageurl": null
      };

      FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;

      await firebaseFirestoreInstance
          .collection("user")
          .doc(uid)
          .set(data)
          .then((value) {
        Fluttertoast.showToast(
            msg: "Registration Successful!",
            timeInSecForIosWeb: 3,
            textColor: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).cursorColor);
        isDone = true;
        setState(() {});
        Navigator.pop(context);
      });
    }

    // validate the form
    void validateForm() async {
      if (formkey.currentState!.validate()) {
        isDone = false;
        setState(() {});
        await _auth
            .createUserWithEmailAndPassword(
                email: mailController.text, password: passwordController.text)
            .then((value) async {
          _auth.currentUser!.sendEmailVerification();
          await sendDetailsToFirestore(
              usernameController.text, mailController.text);
        }).catchError((onError) {
          isDone = true;
          setState(() {});
          Fluttertoast.showToast(
              msg: "Registration failed",
              textColor: Theme.of(context).cursorColor,
              backgroundColor: Theme.of(context).cardColor);
        });
      }
    }

    // signup button
    final signupButton = ElevatedButton(
        onPressed: () {
          validateForm();
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).cursorColor),
            minimumSize: MaterialStateProperty.all(const Size(150, 50)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        child: isDone
            ? Text("Sign Up",
                style: TextStyle(color: Theme.of(context).cardColor))
            : CircularProgressIndicator(color: Theme.of(context).cardColor));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signup.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10, left: 32, right: 32, top: 10),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    usernameField,
                    const SizedBox(height: 20),
                    mailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
                    const SizedBox(height: 40),
                    signupButton
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
