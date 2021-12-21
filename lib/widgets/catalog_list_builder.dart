import 'package:flutter/material.dart';

class CatalogListBuilder extends StatelessWidget {
  const CatalogListBuilder({Key? key, required this.widgetList})
      : super(key: key);

  final List widgetList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widgetList.length,
      itemBuilder: (context, index) {
        return widgetList[index];
      },
    );
  }
}
