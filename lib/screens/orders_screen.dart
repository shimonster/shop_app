import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Orders>(context, listen: false).getOrders();
        },
        child: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).getOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error has ocured'),
                );
              }
              return Consumer<Orders>(builder: (ctx, ordersInfo, _) {
                return ListView.builder(
                    itemCount: ordersInfo.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(ordersInfo.orders[i]));
              });
            }
          },
        ),
      ),
    );
  }
}
