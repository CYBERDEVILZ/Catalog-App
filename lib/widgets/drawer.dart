import 'package:catalog_app/models/usermodel.dart';
import 'package:catalog_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // drawer header
    final drawerHeader = Container(
        color: Theme.of(context).cursorColor,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Stack(children: [
                context.watch<UserModel>().imageurl == null
                    ? CircleAvatar(
                        child: Icon(Icons.account_circle,
                            size: 100, color: Theme.of(context).cardColor),
                        radius: 50,
                        backgroundColor: Theme.of(context).cursorColor,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(context.watch<UserModel>().imageurl),
                        radius: 50,
                        backgroundColor: Theme.of(context).cursorColor,
                      ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        print("redirect to upload page and update firestore");
                      },
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).cardColor,
                      ),
                    ))
              ]),
              const SizedBox(height: 10),
              Text(
                "${context.watch<UserModel>().username}",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).cardColor),
                textScaleFactor: 3,
              ),
              const SizedBox(height: 10),
              Container(
                  height: 25,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).cardColor),
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
                                    color: Theme.of(context).cardColor),
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
                                  color: Theme.of(context).cardColor))
                        ]),
                  ))
            ])));

    // settings
    final settings = InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.settings);
        },
        child: ListTile(
          leading: Icon(Icons.settings, color: Theme.of(context).cursorColor),
          title: Text("Settings",
              style: TextStyle(
                  color: Theme.of(context).cursorColor,
                  fontWeight: FontWeight.bold),
              textScaleFactor: 1.4),
        ));

    return Drawer(
      child: ListView(
        children: [
          drawerHeader,
          settings,
        ],
      ),
    );
  }
}

class Usermodel {}
