import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cartInfo = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartInfo.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton.icon(
                      icon: Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        'ORDER',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        orders.addOrder(
                          cartInfo.cartItems.values.toList(),
                          cartInfo.totalPrice,
                        );
                        cartInfo.clearCart();
                      })
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CartItem(
                cartInfo.cartItems.values.toList()[index].id,
                cartInfo.cartItems.values.toList()[index].pricePerItem,
                cartInfo.cartItems.values.toList()[index].quantity,
                cartInfo.cartItems.values.toList()[index].title,
                cartInfo.cartItems.keys.toList()[index],
              ),
              itemCount: cartInfo.cartItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
