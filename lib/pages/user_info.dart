import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catalog_app/models/usermodel.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';

class UserInfo extends StatelessWidget {
  UserInfo({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("User Info")),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Stack(children: [
                context.watch<UserModel>().imageurl == null
                    ? CircleAvatar(
                        child: Icon(Icons.account_circle,
                            size: 200, color: Theme.of(context).cardColor),
                        radius: 100,
                        backgroundColor: Theme.of(context).cursorColor,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(context.watch<UserModel>().imageurl),
                        radius: 100,
                        backgroundColor: Theme.of(context).cursorColor,
                      ),
                Positioned(
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.edit,
                        size: 35, color: Theme.of(context).cursorColor),
                  ),
                  bottom: 0,
                  right: 0,
                )
              ]),
              const SizedBox(height: 40),
              Text(
                "${context.watch<UserModel>().username}",
                style: TextStyle(color: Theme.of(context).cursorColor),
                textAlign: TextAlign.center,
                textScaleFactor: 3,
              ),
              const SizedBox(height: 40),
              Text(
                "${context.watch<UserModel>().email}",
                style: TextStyle(color: Theme.of(context).cursorColor),
                textAlign: TextAlign.center,
                textScaleFactor: 2,
              ),
              SizedBox(height: 40),
              Container(
                  height: 25,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).cursorColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: FittedBox(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "${context.watch<UserModel>().uid}",
                                style: TextStyle(
                                    color: Theme.of(context).cursorColor),
                              )),
                          InkWell(
                              onTap: () async {
                                ClipboardData data = ClipboardData(
                                    text:
                                        "${Provider.of<UserModel>(context, listen: false).uid}");
                                await Clipboard.setData(data);
                                Fluttertoast.showToast(
                                    msg: "UID Copied!",
                                    textColor: Theme.of(context).cardColor,
                                    backgroundColor:
                                        Theme.of(context).cursorColor);
                              },
                              child: Icon(Icons.copy,
                                  color: Theme.of(context).cursorColor))
                        ]),
                  ))
            ]),
          ],
        ));
  }
}
