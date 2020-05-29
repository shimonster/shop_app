import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/loading_screen.dart';
import './screens/show_products_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './helpers/costom_route.dart';
import './helpers/custom_route_to_home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProducts) => Products(
            auth.token,
            prevProducts != null ? prevProducts.items : [],
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrders) => Orders(auth.token,
              prevOrders != null ? prevOrders.orders : [], auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          update: (ctx, auth, prevCart) => Cart(auth.token, auth.userId,
              prevCart == null ? {} : prevCart.cartItems),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.lightBlueAccent,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomRouteToHomeTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ShowProductsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            MyApp.routeName: (ctx) => MyApp(),
          },
        );
      }),
    );
  }
}
