import 'package:flutter/material.dart';

import '../screens/edit_product_screen.dart';


class UserProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;

  UserProductItem(this.imageUrl, this.title, this.price);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      subtitle: Text('\$$price'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Theme.of(context).errorColor,),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
