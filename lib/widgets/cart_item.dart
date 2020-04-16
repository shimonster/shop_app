import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return Dismissible(
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Are you certain you want to remove this item from the cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: 40,
        ),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.only(
          right: 20,
        ),
      ),
      onDismissed: (_) => cart.removeItemFromCart(productId),
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Chip(
              label: SizedBox(
                height: 20,
                child: Text(
                  '\$$price',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(title),
            subtitle: Text('Price per item: \$${(price * quantity)}'),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                quantity.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
