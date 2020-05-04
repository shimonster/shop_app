import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/cart.dart';

class OrderButton extends StatefulWidget {

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartInfo = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(
      context,
      listen: false,
    );
    return FlatButton(
      child: _isLoading
          ? SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
              height: 15,
              width: 15,
            )
          : Text(
              'ORDER',
            ),
      textColor: Theme.of(context).primaryColor,
      onPressed: _isLoading || cartInfo.cartItems.isEmpty
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await orders.addOrder(
                  cartInfo.cartItems.values.toList(),
                  cartInfo.totalPrice);
              cartInfo.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
