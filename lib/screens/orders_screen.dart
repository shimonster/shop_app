import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _didInit = false;
  var _isLoading = false;

  Future<void> getOrds(bool isRefreshing) async {
    if (!isRefreshing) {
      setState(() {
        _isLoading = true;
      });
    }
    await Provider.of<Orders>(context, listen: false).getOrders();
    if (!isRefreshing) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (!_didInit) {
      getOrds(false);
      _didInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersInfo = Provider.of<Orders>(context);
    final orders = ordersInfo.orders;
    print(['screen', orders]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await getOrds(true);
        },
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, i) => OrderItem(orders[i]),
              ),
      ),
    );
  }
}
