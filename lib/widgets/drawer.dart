import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class ProductsScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
            title: Text('Navigator'),
            automaticallyImplyLeading: false,
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('All Products'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.local_shipping,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Orders'),
            onTap: () =>
                Navigator.of(context).pushNamed(OrdersScreen.routeName),
          ),
        ],
      ),
    );
  }
}
