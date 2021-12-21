import 'package:catalog_app/models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catalog_app/pages/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Details extends StatefulWidget {
  const Details({Key? key, required this.item}) : super(key: key);
  final Items item;

  @override
  State<Details> createState() => _DetailsState();
}

bool isLoading = false;

class _DetailsState extends State<Details> {
  final _auth = FirebaseAuth.instance;

  void quantityAdd(item) {
    if (Cart.quantity.keys.contains(item.id)) {
      Cart.quantity.update(item.id, (value) => value + 1);
    } else {
      Cart.quantity[item.id] = 1;
      Cart.cartList.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 50,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Hero(
                      tag: Key(widget.item.id.toString()),
                      child: Image.network(widget.item.image)),
                  alignment: Alignment.center,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(50),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.item.title,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Divider(
                                  color: Theme.of(context).buttonColor,
                                  endIndent: 10,
                                  height: 2,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.item.desc,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.3),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 3, left: 20, right: 20),
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    "\$${widget.item.price}",
                                    style: TextStyle(
                                      color: Theme.of(context).cursorColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).cardColor),
                                  shape: MaterialStateProperty.all(
                                      StadiumBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .cursorColor)))),
                              onPressed: () async {
                                await _auth.currentUser!.reload().then((value) {
                                  if (_auth.currentUser!.emailVerified) {
                                    quantityAdd(widget.item);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      dismissDirection:
                                          DismissDirection.horizontal,
                                      content: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        child: Text("Item added to cart",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).canvasColor,
                                            )),
                                      ),
                                      behavior: SnackBarBehavior.fixed,
                                      duration: const Duration(seconds: 1),
                                      backgroundColor:
                                          Theme.of(context).cursorColor,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      dismissDirection:
                                          DismissDirection.horizontal,
                                      content: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        child: Text("Verify your email first!",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).canvasColor,
                                            )),
                                      ),
                                      behavior: SnackBarBehavior.fixed,
                                      duration: const Duration(seconds: 3),
                                      backgroundColor:
                                          Theme.of(context).cursorColor,
                                    ));
                                  }
                                }).catchError((e) {
                                  Fluttertoast.showToast(msg: "Network error");
                                });
                              },
                              child: Container(
                                width: 100,
                                alignment: Alignment.center,
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).cursorColor),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
