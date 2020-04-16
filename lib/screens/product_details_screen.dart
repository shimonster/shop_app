import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/ProductDetailsScreen';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final product =
        Provider.of<Products>(context, listen: false).filterForId(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 40, color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                product.description,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
