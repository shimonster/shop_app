import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerElement(IconData icon, String title, String routeName) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
      );
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
            title: Text('Navigator'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.exit_to_app),
                label: Text('Log Out'),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).signOut();
                },
                textColor: Colors.white,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _buildDrawerElement(Icons.home, 'All Products', '/'),
          Divider(),
          _buildDrawerElement(
              Icons.local_shipping, 'Orders', OrdersScreen.routeName),
          Divider(),
          _buildDrawerElement(
              Icons.person, 'My Products', UserProductsScreen.routeName),
        ],
      ),
    );
  }
}
