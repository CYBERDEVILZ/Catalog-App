import 'package:catalog_app/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool loginTapped = false;

  var formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void signIn(BuildContext context, email, password) async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isDone = false;
      });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        setState(() {
          isDone = true;
        });
        Fluttertoast.showToast(
            msg: "Login failed.",
            textColor: Theme.of(context).cursorColor,
            backgroundColor: Theme.of(context).cardColor);
      });
    }
  }

  bool isDone = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        setState(() {
          loginTapped = true;
          isDone = true;
        });

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Column(
          children: [
            Image.asset("assets/images/login_image.png", fit: BoxFit.contain),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: Column(
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Enter the E-mail",
                      labelText: "E-mail",
                      icon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        errorMaxLines: 2,
                        hintText: "Enter the Password",
                        labelText: "Password",
                        icon: Icon(Icons.vpn_key)),
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    validator: (value) {
                      if ((value as String).isEmpty) {
                        return "Password cannot be empty";
                      } else if (value.length < 6) {
                        return "Password must have a minimum of 6 characters";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(loginTapped ? 100 : 10),
                    color: Theme.of(context).cursorColor,
                    child: InkWell(
                      onTap: () => signIn(context, emailController.text,
                          passwordController.text),
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        alignment: Alignment.center,
                        child: loginTapped
                            ? Icon(
                                Icons.done,
                                color: Theme.of(context).cardColor,
                              )
                            : isDone
                                ? Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).cardColor),
                                  )
                                : CircularProgressIndicator(
                                    color: Theme.of(context).cardColor),
                        width: loginTapped ? 75 : 150,
                        height: 50,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.signup);
                          },
                          child: Text("Sign Up",
                              style: TextStyle(
                                  color: Theme.of(context).cursorColor)))
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.forgotPassword);
                    },
                    child: Text("Forgot password",
                        style: TextStyle(color: Theme.of(context).cursorColor)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
