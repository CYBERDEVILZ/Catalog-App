import 'package:catalog_app/models/item.dart';
import 'package:catalog_app/models/usermodel.dart';
import 'package:catalog_app/pages/login_page.dart';
import 'package:catalog_app/utils/routes.dart';
import 'package:catalog_app/widgets/catalog_list_builder.dart';
import 'package:catalog_app/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool waiting = true;

  List actualList = [];

  void loadData() async {
    User? user = _auth.currentUser;
    var catalogJson =
        await rootBundle.loadString('assets/files/catalogdata.json');

    await FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      context.read<UserModel>().setusername(value["username"]);
      context.read<UserModel>().setemail(value["email"]);
      context.read<UserModel>().setuid(user.uid);
      context.read<UserModel>().setimageurl(value["imageurl"]);
    });
    List decodedData = jsonDecode(catalogJson)["products"];
    actualList = decodedData
        .map((items) => ListTileCreator(
            id: items["id"],
            title: items["title"],
            desc: items["description"],
            price: items["price"],
            image: items["image"]))
        .toList();
    waiting = false;
    setState(() {});
  }

  void logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Catalog App"),
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: logout),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).dividerColor,
          onPressed: () {
            Navigator.pushNamed(context, Routes.cart);
          },
          elevation: 3,
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.black,
          ),
        ),
        body: waiting
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).cursorColor,
              ))
            : CatalogListBuilder(widgetList: actualList),
        drawer: MyDrawer(),
      ),
    );
  }
}
