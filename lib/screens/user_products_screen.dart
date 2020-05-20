import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/UserProductsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Products>(context, listen: false).getProducts(true),
          builder: (ctx, snapshot) {
            print(snapshot);
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: const CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<Products>(context, listen: false)
                          .getProducts(true);
                    },
                    child: Consumer<Products>(
                      builder: (ctx, userProducts, _) => ListView.builder(
                        itemCount: userProducts.items.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                UserProductItem(
                                  userProducts.items[i].imageURL,
                                  userProducts.items[i].title,
                                  userProducts.items[i].price,
                                  userProducts.items[i].id,
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
          }),
    );
  }
}
