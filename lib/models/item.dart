import 'package:catalog_app/pages/details.dart';
import 'package:flutter/material.dart';

class Items {
  final int id;
  final String title;
  final String desc;
  final num price;
  final String image;

  Items(this.id, this.title, this.desc, this.price, this.image);
}

class ListTileCreator extends StatelessWidget {
  const ListTileCreator(
      {Key? key,
      required this.id,
      required this.title,
      required this.desc,
      required this.price,
      required this.image})
      : super(key: key);

  final int id;
  final String title;
  final String desc;
  final num price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Details(item: Items(id, title, desc, price, image))));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  child: Hero(
                    tag: Key(id.toString()),
                    child: Image.network(
                      image,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Container(
                      height: 110,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "\u20b9$price",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).cursorColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
