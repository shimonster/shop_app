import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../widgets/icon_badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';

enum FilterSelected {
  favorites,
  all,
}

class ShowProductsScreen extends StatefulWidget {
  @override
  _ShowProductsScreenState createState() => _ShowProductsScreenState();
}

class _ShowProductsScreenState extends State<ShowProductsScreen> {
  var _onlyShowFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, button) => IconBadge(
              button,
              cart.itemCount.toString(),
              Colors.red[800],
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterSelected value) {
              setState(() {
                if (value == FilterSelected.favorites) {
                  _onlyShowFavorites = true;
                } else {
                  _onlyShowFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterSelected.favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterSelected.all,
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(_onlyShowFavorites),
    );
  }
}
