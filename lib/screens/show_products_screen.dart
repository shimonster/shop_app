import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';
import '../main.dart';
import '../widgets/icon_badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

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
    print('products screen build was run');
    Widget buildScaffold(Widget child) {
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
          body: child);
    }

    return FutureBuilder(
      future: Provider.of<Products>(context, listen: false).getProducts(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return buildScaffold(
            Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (dataSnapshot.error != null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Oops. An Error Has Occurred.'),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                    top: MediaQuery.of(context).size.height * 0.05,
                    bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/shrug.png',
                        height: MediaQuery.of(context).size.height * 0.5,
                      ),
                      Text(
                        'Oops. Looks like an error has occured. Try restarting the app.',
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                      RaisedButton(
                        child: Text('Restart'),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(MyApp.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return buildScaffold(
              ProductsGrid(_onlyShowFavorites),
            );
          }
        }
      },
    );
  }

}