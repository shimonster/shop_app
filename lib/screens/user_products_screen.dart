import 'package:flutter/material.dart';

import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/UserProductsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
