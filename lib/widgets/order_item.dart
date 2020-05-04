import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 3,
            )),
            child: ListTile(
              title: Text('\$${widget.order.price.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('MM/dd/yyyy, hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
          ),
          if (expanded)
            Container(
              height: min(widget.order.products.length * 75.0,
                  MediaQuery.of(context).size.height * 1 / 3),
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return Container(
                    child: ListTile(
                      leading: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          (widget.order.products[i].pricePerItem *
                                  widget.order.products[i].quantity)
                              .toStringAsFixed(2),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(widget.order.products[i].title),
                      subtitle: Text(
                          widget.order.products[i].pricePerItem.toStringAsFixed(2)),
                      trailing: Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          '${widget.order.products[i].quantity}x',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.order.products.length,
              ),
            ),
        ],
      ),
    );
  }
}
