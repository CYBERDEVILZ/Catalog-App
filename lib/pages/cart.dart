import 'package:catalog_app/models/item.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  static List<Items> cartList = [];
  static Map<int, num> quantity = {};

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _razorpay = Razorpay();

  void increase(id) {
    Cart.quantity.update(id, (value) => value + 1);
    setState(() {});
  }

  void decrease(item) {
    if (Cart.quantity[item.id]! > 1) {
      Cart.quantity.update(item.id, (value) => value - 1);
      setState(() {});
    } else {
      Cart.cartList.remove(item);
      Cart.quantity.remove(item.id);
    }
    setState(() {});
  }

  void delete(item) {
    Cart.cartList.remove(item);
    Cart.quantity.remove(item.id);
    setState(() {});
  }

  int getTotalPrice() {
    num price = 0;
    for (var i = 0; i < Cart.cartList.length; i++) {
      price += Cart.cartList[i].price * Cart.quantity[Cart.cartList[i].id]!;
    }
    return (price * 100).toInt();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalPrice();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void order({required int amount}) async {
    String username = "rzp_test_dqC5RnBflXlKOs";
    String password = "SEugTTMKyyBNDeuDX4JdC8Yv";
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode("$username:$password"));

    var data = json.encode({"amount": amount, "currency": "INR"});

    Response response = await post(
        Uri.parse("https://api.razorpay.com/v1/orders"),
        headers: {
          "authorization": basicAuth,
          "content-type": "application/json"
        },
        body: data);
    var response_json = json.decode(response.body);
    print(response_json);

    var options = {
      'key': username,
      'amount': response_json["amount"], //in the smallest currency sub-unit.
      'name': 'Catalog App',
      'order_id': response_json["id"], // Generate order_id using Orders API
      'description': 'Total Price',
    };

    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Cart")),
        body: Column(
          children: [
            Expanded(
              child: ListView(children: [
                ...Cart.cartList
                    .map((item) => Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 110,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: Image.network(
                                    item.image,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Container(
                                      height: 110,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                item.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "\$${item.price}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .cursorColor),
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => decrease(item),
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Theme.of(context)
                                                          .accentColor
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${Cart.quantity[item.id]}"),
                                                  GestureDetector(
                                                      onTap: () =>
                                                          increase(item.id),
                                                      child: Icon(
                                                          Icons.arrow_drop_up,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor
                                                                  .withOpacity(
                                                                      0.3)))
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () => delete(item),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Theme.of(context).cardColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      child: FittedBox(
                        child: Text(
                          "\$${getTotalPrice() / 100}",
                          style:
                              TextStyle(color: Theme.of(context).cursorColor),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: Cart.cartList.isEmpty
                          ? null
                          : () {
                              order(amount: getTotalPrice());
                            },
                      child: Text("Proceed to Buy"))
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            )
          ],
        ));
  }
}
