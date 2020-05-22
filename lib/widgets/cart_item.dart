import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return Dismissible(
      key: ValueKey(widget.id),
      confirmDismiss: (_) async {
        var shouldDelete = false;
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'Are you certain you want to remove this item from the cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  shouldDelete = false;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  shouldDelete = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        setState(() {
          isLoading = true;
        });
        await cart.removeItemFromCart(widget.productId);
        setState(() {
          isLoading = false;
        });
        return shouldDelete;
      },
      direction: DismissDirection.endToStart,
      background: isLoading
          ? Card(
              margin: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
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
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Chip(
              label: SizedBox(
                height: 20,
                child: Text(
                  '\$${widget.price}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(widget.title),
            subtitle: Text(
                'Price per item: \$${(widget.price * widget.quantity).toStringAsFixed(2)}'),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                widget.quantity.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
