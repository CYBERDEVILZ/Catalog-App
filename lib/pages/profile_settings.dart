import 'package:catalog_app/models/usermodel.dart';
import 'package:catalog_app/pages/login_page.dart';
import 'package:catalog_app/utils/routes.dart';
import 'package:catalog_app/widgets/delete_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 2),
            child: Text(
              "${context.watch<UserModel>().email}",
              textScaleFactor: 1.1,
              style: TextStyle(
                  color: Theme.of(context).accentColor.withOpacity(0.4),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
            child: Text(
              "${context.watch<UserModel>().username}",
              textScaleFactor: 3,
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
              title: const Text("Update Email"),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pushNamed(context, Routes.updateEmail);
              }),
          ListTile(
              title: const Text("Change / Reset Password"),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pushNamed(context, Routes.forgotPassword);
              }),
          const SizedBox(height: 75),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) => const DeleteUser());
              },
              child: const Text(
                "Delete User",
                textScaleFactor: 1.3,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  fixedSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width, 50)),
                  elevation: MaterialStateProperty.all(0)),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton(
              onPressed: () async {
                final _auth = FirebaseAuth.instance;
                await _auth.signOut();
                _auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  }
                });
              },
              child: const Text(
                "Sign Out",
                textScaleFactor: 1.3,
              ),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.red, width: 1)),
                  overlayColor:
                      MaterialStateProperty.all(Colors.red.withOpacity(0.1)),
                  fixedSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width, 50))),
            ),
          ),
        ],
      ),
    );
  }
}
