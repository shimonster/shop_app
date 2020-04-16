import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/show_products_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.lightBlueAccent,
            fontFamily: 'Lato'),
        home: ShowProductsScreen(),
        routes: {
          //'/': (ctx) => ShowProductsScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
        },
      ),
    );
  }
}
